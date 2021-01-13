import R from 'ramda'
import { upsertTalent } from './talents.service'

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
 * Get action from payload record
 */
const getAction = R.compose(
  R.toUpper,
  R.prop('action')
)

/**
 * Processa uma mensagem da fila
 * @param {*} message One Record SQS Message
 * @return {Promise<void>}
 */
const processMessage = async message => {
  const action = getAction(message)
  const talent = getPayload(message)

  if (action === 'CREATE' || action === 'UPDATE') {
    await upsertTalent(talent)
    return
  }

  throw new Error(`No action for "${action}`)
}

/**
 * Função de manipulação do worker através de evento de Receive Message do AWS SQS
 * @param {*} event aws lambda event
 */
export const workerHandler = async event => {
  const records = getRecords(event)
  await records.reduce(async (acc, record) => {
    await acc
    try {
      await processMessage(record)
    } catch (e) {
      console.error('Error on process message', JSON.stringify(e))
      console.log('Message', JSON.stringify(record))
      throw e
    }
  }, Promise.resolve())
}
