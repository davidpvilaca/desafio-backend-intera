import { createOpening } from './openings.service'
import R from 'ramda'

/**
 * Resolver da mutation "createOpenings"
 * @param {*} arguments
 */
const createOpeningHandler = async ({ data: talent }) => {
  const result = await createOpening(talent)
  return {
    status: 'OK',
    record: result
  }
}

/**
 * Função de manipulação do server (graphql) através do AWS Appsync
 * @param {*} event aws lambda event
 */
export const serverHandler = async event => {
  // Mapeamento de todos resolvers para suas respectivas funções
  const eventMapper = {
    createOpening: createOpeningHandler
  }

  if (!R.keys(eventMapper).some(k => k === event.field)) {
    throw new Error('Invalid event field in lambda execution')
  }

  return eventMapper[event.field](event.arguments)
}
