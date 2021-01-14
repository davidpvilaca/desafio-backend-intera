import R from 'ramda'
import { scanOpeningsByTalent, scanTalentsByOpening } from './data.service'

const getFrameworkValue = (openingFrameworks, talentFrameworkSkills) => R.intersection(openingFrameworks.map(o => o.framework), talentFrameworkSkills.map(t => t.framework)).length

const getLanguageValue = (openingLanguages, talentLanguageSkills) => R.intersection(openingLanguages.map(o => o.language), talentLanguageSkills.map(t => t.language)).length

const getSpeakLanguageValue = (openingSpeakLanguages, talentSpeakLanguages) => R.intersection(openingSpeakLanguages, talentSpeakLanguages).length * 0.3

/**
 * Recebe um Talent e faz o match com openings
 *
 * @param {*} talent
 */
const matchTalent = async talent => {
  console.log('MATCH TALENT')
  const openings = await scanOpeningsByTalent(talent)

  return openings.map(opening => {
    const frameworksValue = getFrameworkValue(opening.frameworks, talent.skill.frameworkSkills)
    const languagesValue = getLanguageValue(opening.languages, talent.skill.languages)
    const speakLanguagesValue = getSpeakLanguageValue(opening.speakLanguages, talent.skill.speakLanguages)
    console.log({ frameworksValue, languagesValue, speakLanguagesValue })

    return {
      type: 'OPENING',
      payload: opening,
      matchRef: talent,
      matchValue: frameworksValue + languagesValue + speakLanguagesValue
    }
  }).filter(result => result.matchValue >= 1)
}

/**
 * Recebe um Opening e faz o match com talents
 *
 * @param {*} opening
 */
const matchOpening = async opening => {
  console.log('MATCH OPENING')
  const talents = await scanTalentsByOpening(opening)

  return talents.map(talent => {
    const frameworksValue = getFrameworkValue(opening.frameworks, talent.skill.frameworkSkills)
    const languagesValue = getLanguageValue(opening.languages, talent.skill.languages)
    const speakLanguagesValue = getSpeakLanguageValue(opening.speakLanguages, talent.skill.speakLanguages)

    return {
      type: 'TALENT',
      payload: talent,
      matchRef: opening,
      matchValue: frameworksValue + languagesValue + speakLanguagesValue
    }
  }).filter(result => result.matchValue >= 1)
}

/**
 * Aplica o match de acordo com o type informado
 *
 * @param {*} payload
 * @param {*} type
 */
export const applyMatch = (payload, type) => {
  const typeMapper = {
    TALENT: matchTalent,
    OPENING: matchOpening
  }
  if (R.includes(type, R.keys(typeMapper))) {
    return typeMapper[type](payload)
  }

  throw new Error(`No type for "${type}" lambda execution`)
}
