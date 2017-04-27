# devtools::install_github("wlandau/JeffLeekMeme")
library(JeffLeekMeme)

#* @post /
function(req){
  dispatchAlexaRequest(req, intent=function(name, slots, ...){
    if (name=="tellfact"){
      alexaResponse(output=JeffLeekMeme::JeffLeek())
    } else {
      alexaResponse(output="I don't know how to process this request...")
    }
  })
}
