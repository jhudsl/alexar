
#' Dispatch Alexa Request to Handlers
#'
#' @export
dispatchAlexaRequest <- function(req, intent=function(name, slots, ...){},
                                 launch=function(...){}, end=function(...){}){
  validateAlexaRequest(req)
  request <- req$args$request

  type <- request$type

  if (type == "IntentRequest"){
    intent(name=request$intent$name, slots=request$intent$slots)
  } else if (type == "LaunchRequest"){
    launch()
  } else if (type == "SessionEndedRequest"){
    end()
  } else {
    stop("Unrecognized request type: ", type)
  }
}
