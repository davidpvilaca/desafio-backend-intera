import AWS from 'aws-sdk'
import R from 'ramda'
import { AWSDynamoConfig, ENVIRONMENTS } from './config'

const dynamo = new AWS.DynamoDB.DocumentClient(AWSDynamoConfig)
const { openingsTableName, talentsTableName } = ENVIRONMENTS

export const scanTalentsByOpening = async opening => {
  const params = {
    TableName: talentsTableName,
    FilterExpression: `person.address.#s = :s AND
    person.address.city = :city`,
    ExpressionAttributeNames: {
      '#s': 'state'
    },
    ExpressionAttributeValues: {
      ':s': opening.company.address.state,
      ':city': opening.company.address.city
    }
  }

  const result = await dynamo.scan(params).promise()

  return (R.not(R.isEmpty(result)) && R.not(R.isNil(result)) && R.not(R.isNil(result.Items))) ? result.Items : []
}

export const scanOpeningsByTalent = async talent => {
  const params = {
    TableName: openingsTableName,
    FilterExpression: `company.address.#s = :s AND
    company.address.city = :city`,
    ExpressionAttributeNames: {
      '#s': 'state'
    },
    ExpressionAttributeValues: {
      ':s': talent.person.address.state,
      ':city': talent.person.address.city
    }
  }

  const result = await dynamo.scan(params).promise()

  return (R.not(R.isEmpty(result)) && R.not(R.isNil(result)) && R.not(R.isNil(result.Items))) ? result.Items : []
}
