import R from 'ramda'

/**
 * get environment variable
 * @memberof config
 * @param {string} env environment variable name
 * @param {string} [defaultValue=''] default value
 * @returns {string} environment variable value
 */
const getEnv = (env, defaultValue = '') => process.env[env] || defaultValue

// Common aws config
const AWSConfig = {
  region: getEnv('AWS_REGION', 'us-east-2')
}

// AWS DynamoDB config
export const AWSDynamoConfig = R.merge(
  AWSConfig,
  {
    region: getEnv('AWS_DYNAMO_REGION', 'us-east-2'),
    apiVersion: getEnv('AWS_DYNAMO_APIVERSION', '2012-08-10')
  }
)

// AWS SQS config
export const AWSSqsConfig = R.merge(
  AWSConfig,
  {
    region: getEnv('AWS_SQS_REGION', 'us-west-2'),
    apiVersion: getEnv('AWS_SQS_APIVERSION', '2012-11-05')
  }
)

// Environments variables
export const ENVIRONMENTS = {
  tableName: getEnv('DYNAMO_DB', 'intera_talents'),
  queueUrl: getEnv('SQS_QUEUE_URL'),
  errorQueueUrl: getEnv('SQS_ERROR_QUEUE_URL'),
  matchQueueUrl: getEnv('SQS_MATCH_QUEUE_URL')
}
