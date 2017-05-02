#' Prepare a Response for Alexa
#'
#' Form a response object that satisfies the requirements of a response to an
#' Alexa custom skill request. All objects returned for an Alexa custom skill
#' should be an object formed using this function.
#' @param output A character string containing the words Alexa should read back
#'   to the request. Converted to `PlainTextSpeech` in the Alexa API.
#' @param card A list containing the contents of the card to be displayed in
#'   response to the request. See
#'   https://developer.amazon.com/public/solutions/alexa/alexa-skills-kit/docs/alexa-skills-kit-interface-reference#card-object
#'    for more information about how the card should be structured.
#' @param reprompt A character string representing the `PlainTextSpeech` to be
#'   included as the reprompt object. From the Amazon documentation: "The object
#'   containing the outputSpeech to use if a re-prompt is necessary. This is
#'   used if the your service keeps the session open after sending the response,
#'   but the user does not respond with anything that maps to an intent defined
#'   in your voice interface while the audio stream is open. If this is not set,
#'   the user is not re-prompted."
#'   https://developer.amazon.com/public/solutions/alexa/alexa-skills-kit/docs/alexa-skills-kit-interface-reference#response-object
#' @param attributes A list of data to attach to this Alexa session.
#'   Subsequent requests from this session will include whatever data you
#'   provide here in the `attributes` field.
#' @param endSession If `TRUE`, will force the session to close as a result of
#'   this response.
#'
#' @export
alexaResponse <- function(output, card, reprompt, attributes, endSession=FALSE) {
  if (missing(output) && missing(reprompt)) {
    stop("You must provide either an `output` or a `reprompt` value.")
  }

  res <- list()

  if (!missing(output)){
    res$outputSpeech <- list(type="PlainText", text=output)
  }

  if (!missing(card)){
    res$card <- card
  }

  if (!missing(reprompt)){
    res$reprompt <- list(outputSpeech=list(type="PlainText", text=reprompt))
  }

  sessionAttributes <- req$args$session$attributes
  if (!missing(attributes)){
    sessionAttributes <- c(sessionAttributes, attributes)
  }

  toReturn <- list(
    version="1.0",
    response=res,
    sessionAttributes = sessionAttributes,
    shouldEndSession = endSession
  )

  toReturn
}
