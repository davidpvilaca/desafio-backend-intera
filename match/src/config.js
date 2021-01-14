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

// Environments variables
export const ENVIRONMENTS = {
  talentsTableName: getEnv('TALENTS_DYNAMO_DB', 'intera_talents'),
  openingsTableName: getEnv('OPENINGS_DYNAMO_DB', 'intera_openings')
}
