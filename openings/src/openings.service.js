import AWS from 'aws-sdk'
import R from 'ramda'
import { v4 as uuid } from 'uuid'
import { AWSDynamoConfig, AWSSqsConfig, ENVIRONMENTS } from './config'

const sqs = new AWS.SQS(AWSSqsConfig)
const dynamo = new AWS.DynamoDB.DocumentClient(AWSDynamoConfig)
const { tableName } = ENVIRONMENTS

/**
 * Gera um ID para o dado e envia para a fila
 * @param {any} opening
 */
export const createOpening = async opening => {
  const openingWithId = {
    ...opening,
    id: uuid()
  }
  const params = {
    QueueUrl: ENVIRONMENTS.queueUrl,
    MessageBody: JSON.stringify({
      action: 'CREATE',
      payload: openingWithId
    })
  }
  try {
    const result = await sqs.sendMessage(params).promise()

    if (typeof result.MessageId === 'undefined') {
      return throwError(params, new Error('No message id response!'))
    }

    return openingWithId
  } catch (err) {
    return throwError(params, err)
  }
}

/**
 * Retorna um registro do banco de dados de Openings
 * caso não haja, retorna null
 * @param {*} id identificador
 */
export const getOpening = async id => {
  const params = {
    TableName: tableName,
    Key: { id }
  }

  const result = await dynamo.get(params).promise()

  return (R.not(R.isEmpty(result)) && R.not(R.isNil(result)) && R.not(R.isNil(result.Item))) ? result.Item : null
}

export const upsertOpening = async opening => {
  const inserted = await getOpening(opening.id)
  const now = new Date().toISOString()

  if (inserted) { // UPDATE
    opening = {
      ...opening,
      updatedAt: now
    }
    const params = {
      TableName: tableName,
      Key: { id: opening.id },
      UpdateExpression: `set #title = :title,
      #description = :description,
      #company = :company,
      #languages = :languages,
      #frameworks = :frameworks,
      #speakLanguages = :speakLanguages,
      #updatedAt = :updatedAt`,
      ExpressionAttributeNames: {
        '#title': 'title',
        '#description': 'description',
        '#company': 'company',
        '#languages': 'languages',
        '#frameworks': 'frameworks',
        '#speakLanguages': 'speakLanguages',
        '#updatedAt': 'updatedAt'
      },
      ExpressionAttributeValues: {
        ':title': opening.title,
        ':description': opening.description,
        ':company': opening.company,
        ':languages': opening.languages,
        ':frameworks': opening.frameworks,
        ':speakLanguages': opening.speakLanguages,
        ':updatedAt': now
      },
      ReturnValues: 'UPDATED_NEW'
    }

    await dynamo.update(params).promise()
  } else {
    // CREATE
    opening = {
      ...opening,
      createdAt: now,
      updatedAt: now
    }
    const params = {
      TableName: tableName,
      Item: opening
    }

    await dynamo.put(params).promise()
  }

  try {
    await sendToMatch(opening)
  } catch (e) {
    console.error('Send to match ERROR')
    throwError(e)
  }

  return opening
}

/**
 * Envia o objeto criado para a fila de fazer match
 *
 * @param {*} opening
 */
const sendToMatch = async opening => {
  const params = {
    QueueUrl: ENVIRONMENTS.matchQueueUrl,
    MessageBody: JSON.stringify({
      type: 'OPENING',
      payload: opening
    })
  }
  const result = await sqs.sendMessage(params).promise()

  if (typeof result.MessageId === 'undefined') {
    return throwError(params, new Error('No message id response!'))
  }

  return result
}

/**
 * Generic handle error
 * @param {*} obj actual object process
 * @param {*} error general error
 */
const throwError = async (obj, error) => {
  const params = {
    QueueUrl: ENVIRONMENTS.errorQueueUrl,
    MessageBody: JSON.stringify({
      ...obj,
      error
    })
  }

  await sqs.sendMessage(params).promise()

  throw error
}
