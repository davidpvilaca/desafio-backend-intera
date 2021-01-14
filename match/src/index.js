import R from 'ramda'
import { applyMatch } from './match'

/**
 * Obtém a propriedade 'Records'
 * do SQS event message
 */
const getRecords = R.ifElse(
  R.allPass([
    R.is(Object),
    R.has('Records'),
    R.compose(
      R.is(Array),
      R.prop('Records')
    )
  ]),
  R.compose(
    R.map(record => JSON.parse(record.body)),
    R.prop('Records')
  ),
  e => {
    console.log(`Not records found in ${JSON.stringify(e)}`)
    return []
  }
)

/**
 * Get payload from record
 */
const getPayload = R.prop('payload')

/**
 * Get payload from record
 */
const getType = R.compose(
  R.toUpper,
  R.prop('type')
)

/**
 * Lambda handler para função de match
 *
 * @param {*} event AWS Lambda event
 */
export const handler = async event => {
  const records = getRecords(event)
  await records.reduce(async (acc, record) => {
    await acc
    try {
      const results = await applyMatch(getPayload(record), getType(record))
      console.log('\n\nRESULT >>>\n\n')
      results.forEach(result => {
        const opening = result.type === 'OPENING' ? result.payload : result.matchRef
        const talent = result.type === 'TALENT' ? result.payload : result.matchRef
        console.log(`OPENING: ${opening.title} - ${opening.description}`)
        console.log(`Talent Name: ${talent.person.name}`)
        console.log(`Match value: ${result.matchValue}`)
        console.log('\n\n')
      })
    } catch (e) {
      console.error('Error on process message', e)
      console.log('Message', JSON.stringify(record))
      throw e
    }
  }, Promise.resolve())
}
