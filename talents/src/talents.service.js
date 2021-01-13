import AWS from 'aws-sdk'
import R from 'ramda'
import { v4 as uuid } from 'uuid'
import { AWSDynamoConfig, AWSSqsConfig, ENVIRONMENTS } from './config'

const sqs = new AWS.SQS(AWSSqsConfig)
const dynamo = new AWS.DynamoDB.DocumentClient(AWSDynamoConfig)
const { tableName } = ENVIRONMENTS

/**
 * Generate ID for talent and send to queue
 * @param {any} talent
 */
export const createTalent = async talent => {
  const talentWithId = {
    ...talent,
    id: uuid()
  }
  const params = {
    QueueUrl: ENVIRONMENTS.queueUrl,
    MessageBody: JSON.stringify({
      action: 'CREATE',
      payload: talentWithId
    })
  }
  try {
    const result = await sqs.sendMessage(params).promise()

    if (typeof result.MessageId === 'undefined') {
      return throwError(params, new Error('No message id response!'))
    }

    return talentWithId
  } catch (err) {
    return throwError(params, err)
  }
}

export const getTalent = async id => {
  const params = {
    TableName: tableName,
    Key: { id }
  }

  const result = await dynamo.get(params).promise()

  return (R.not(R.isEmpty(result)) && R.not(R.isNil(result)) && R.not(R.isNil(result.Item))) ? result.Item : null
}

export const upsertTalent = async talent => {
  const inserted = await getTalent(talent.id)
  const now = new Date().toISOString()

  if (inserted) { // UPDATE
    talent = {
      ...talent,
      updatedAt: now
    }
    const params = {
      TableName: tableName,
      Key: { id: talent.id },
      UpdateExpression: `set #s = :s,
      #p = :p,
      #updatedAt = :updatedAt`,
      ExpressionAttributeNames: {
        '#s': 'skill',
        '#p': 'person',
        '#updatedAt': 'updatedAt'
      },
      ExpressionAttributeValues: {
        ':s': talent.skill,
        ':p': talent.person,
        ':updatedAt': now
      },
      ReturnValues: 'UPDATED_NEW'
    }

    await dynamo.update(params).promise()
  } else {
    // CREATE
    talent = {
      ...talent,
      createdAt: now,
      updatedAt: now
    }
    const params = {
      TableName: tableName,
      Item: talent
    }

    await dynamo.put(params).promise()
  }

  try {
    await sendToMatch(talent)
  } catch (e) {
    console.error('Send to match ERROR')
    throwError(e)
  }

  return talent
}

/**
 * Envia o objeto criado para a fila de fazer match
 *
 * @param {*} talent
 */
const sendToMatch = async talent => {
  const params = {
    QueueUrl: ENVIRONMENTS.matchQueueUrl,
    MessageBody: JSON.stringify({
      type: 'TALENT',
      payload: talent
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
