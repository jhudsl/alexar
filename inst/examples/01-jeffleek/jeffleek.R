# devtools::install_github("wlandau/JeffLeekMeme")

facts <- JeffLeekMeme::allJeffLeek()

#* @post /
#* @serializer unboxedJSON
function(req){
  dispatchAlexaRequest(req, intent=function(name, slots, ...){
    if (name=="tellfact"){
      fact <- facts[sample(1:nrow(facts), 1),]
      alexaResponse(output=fact$fact, card=
                      list(type="Simple", title="Jeff Leek Fact",
                           content=paste(fact$fact, fact$author, sep="\r\n -")))
    } else {
      alexaResponse(output="I don't know how to process this request...")
    }
  })
}

# unboxedJsonSerializer <- function(){
#   function(val, req, res, errorHandler){
#     tryCatch({
#       json <- jsonlite::toJSON(val, auto_unbox = TRUE)
#
#       res$setHeader("Content-Type", "application/json")
#       res$body <- json
#
#       return(res$toResponse())
#     }, error=function(e){
#       errorHandler(req, res, e)
#     })
#   }
# }
# plumber::addSerializer("unboxedJSON", unboxedJsonSerializer)
