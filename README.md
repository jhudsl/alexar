# alexar

[![Build Status](https://travis-ci.org/trestletech/alexar.svg?branch=master)](https://travis-ci.org/trestletech/alexar)
[![codecov](https://codecov.io/gh/trestletech/alexar/branch/master/graph/badge.svg)](https://codecov.io/gh/trestletech/alexar)

This package provides a handful of utilites to help build an Alexa Custom Skill using the [plumber R package](http://plumber.trestletech.com). There are two primary functions that you'll use initially from this package: `dispatchAlexaRequest` and `alexaResponse`.

## Setup an Alexa Custom Skill

We recommend that you start by reading [the high-level documentation for Alexa custom skills](https://developer.amazon.com/public/solutions/alexa/alexa-skills-kit/overviews/understanding-custom-skills) from Amazon. This will give you a good feel for what the components of a custom skill are and how this whole process works.

A more detailed guide to the various steps you'll need to complete is available [here](https://developer.amazon.com/public/solutions/alexa/alexa-skills-kit/overviews/steps-to-build-a-custom-skill). The important steps for an alexar-based service are:

1. Setup a server where your alexar/plumber code will live
2. Register and setup the skill in the developer portal
3. Build your interaction model in Amazon's "skill builder"
4. Write and test the code for your skill
5. Submit your skill for certification

### Step 1 - Setup a server

You'll need a server where your plumber and alexar code live. Amazon requires that this server also have a valid SSL certificate, which means that it will also need a domain name associated with it. You'll need a server that satisfies all of these requirements in order for Amazon to certify your custom skill.

The plumber package has some utilities that help in this regard. In the latest development build (use `devtools::install_github("trestletech/plumber")` to install), you can use the `plumber::do_provision()` and `plumber::do_configure_https()` functions to easily create a server on DigitalOcean that is running your plumber service with an SSL certificate. 

The only piece you'll need to provide is a domain name pointing to your DigitalOcean server -- this needs to be done before you can be granted an SSL certificate on your server.

A video guide to this process is available:
 
 - [Setup a DigitalOcean server running plumber](https://www.youtube.com/watch?v=OiREOPog3Cs)
 - [Deploy SSL on the server you just setup](https://www.youtube.com/watch?v=EpgdrRTBZwg)

### Step 2 - Register and setup the skill in the developer portal

This is all handled between you and Amazon. See their guide [here](https://developer.amazon.com/public/solutions/alexa/alexa-skills-kit/overviews/steps-to-build-a-custom-skill#step-2-set-up-the-skill-in-the-developer-portal).

### Step 3 - Build your interaction model in Amazon's "skill builder"

Again, this is just handled between you and Amazon. Their documentation is [here](https://developer.amazon.com/public/solutions/alexa/alexa-skills-kit/overviews/steps-to-build-a-custom-skill#step-3-use-the-voice-design-to-build-your-interaction-model).

### Step 4 - Write and test the code for your skill

This is where you'll actually use the alexar package. Your job in this stage is to define a plumber API that uses alexar to define a valid Alexa custom skill. You can see an example of a basic service at [inst/examples/01-jeffleek](https://github.com/trestletech/alexar/blob/master/inst/examples/01-jeffleek/jeffleek.R).

The most basic example would be something like

```r
library(alexar)

#* @post /
#* @serializer unboxedJSON
function(req){
  dispatchAlexaRequest(req, intent=function(name, slots, ...){
    if (name=="intent1"){
      alexaResponse(output="This is how I respond to intent1!")
    } else if (name=="intent2"){
      alexaResponse(output="This is what I say to intent2!")
    }
  }, launch=function(){
    alexaResponse("You can ask for inten1 or intent2")
  })
}
```

More documentation from Amazon is available [here](https://developer.amazon.com/public/solutions/alexa/alexa-skills-kit/overviews/steps-to-build-a-custom-skill#step-4-write-and-test-the-code-for-your-skill). 

### Step 5 - Submit your skill for certification

This is between you and Amazon. Their documentation is available [here](https://developer.amazon.com/public/solutions/alexa/alexa-skills-kit/overviews/steps-to-build-a-custom-skill#step-6-submit-your-skill-for-certification).

