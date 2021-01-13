import { serverHandler } from './server'
import { workerHandler } from './worker'

/**
 * Lambda handler do escopo de Talents Service.
 * A Lambda deve ser executada acrescentando um "scope"
 * para diferenciar o server (graphql queries) do worker
 * (quem efetua a gravação de fato no banco de dados).
 *
 * @param {*} event AWS Lambda event
 */
export const handler = async event => {
  console.log('started lambda')
  if (event.scope === 'server') {
    console.log('server run')
    const result = await serverHandler(event)
    return result
  }

  console.log('worker run')
  const result = await workerHandler(event)
  return result
}
