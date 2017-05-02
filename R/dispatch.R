
#' Dispatch Alexa Request to Handlers
#'
#' A convenience function that routes an incoming plumber request to the
#' appropriate handler given the request's type.
#'
#' Any of the three parameters that are not provided will just function as no-ops.
#'
#' See
#' https://developer.amazon.com/public/solutions/alexa/alexa-skills-kit/docs/custom-standard-request-types-reference
#' for complete details on the three intent types.
#' @param req The plumber request to dispatch on.
#' @param intent The function to invoke if the request is of type `IntentRequest`.
#' @param launch The function to invoke if the request is of type `LaunchRequest`.
#' @param end The function to invoke if the request is of type `SessionEndedRequest`.
#' @details All provided handlers should accept `...` as this API is subject to
#' change and new arguments may be added. Having your handler functions accept
#' `...` is a way of ensuring that they won't break if/when alexar begins
#' passing in new parameters that your code doesn't recognize or use.
#' @export
dispatchAlexaRequest <- function(req, intent=function(name, slots, attributes, ...){},
                                 launch=function(...){}, end=function(attributes, ...){}){
  validateAlexaRequest(req)
  request <- req$args$request

  type <- request$type
  attributes <- req$args$session$attributes
  if (is.null(attributes)){
    attributes <- list()
  }

  if (type == "IntentRequest"){
    intent(name=request$intent$name, slots=request$intent$slots, attributes=attributes)
  } else if (type == "LaunchRequest"){
    launch()
  } else if (type == "SessionEndedRequest"){
    end(attributes=attributes)
  } else {
    stop("Unrecognized request type: ", type)
  }
}
