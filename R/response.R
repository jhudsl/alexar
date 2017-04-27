#' Prepare a Response for Alexa
#'
#' Form a response object that satisfies the requirements of a response to an
#' Alexa custom skill request.
#' @export
alexaResponse <- function(output, card, reprompt, endSession=FALSE) {
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

  list(
    version="1.0",
    response=res,
    shouldEndSession = endSession
  )
}
