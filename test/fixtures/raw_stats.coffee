module.exports =
  get: ->
    now = Date.now()

    pageTiming:
      navigationStart: now
      redirectStart: now + 1
      redirectEnd: now + 2
      fetchStart: now + 3
      domainLookupStart: now + 4
      domainLookupEnd: now + 5
      connectStart: now + 6
      secureConnectionStart: now + 7
      connectEnd: now + 8
      requestStart: now + 9
      responseStart: now + 10
      responseEnd: now + 11
      domLoading: now + 12
      domInteractive: now + 13
      domContentLoadedEventStart: now + 14
      domContentLoadedEventEnd: now + 15
      domComplete: now + 16
      loadEventStart: now + 17
      loadEventEnd: now + 18
      unloadEventEnd: 0
      unloadEventStart: 0
    resourceTiming: [
      entryType: 'resource'
      responseEnd: 1280.05100000883
      responseStart: 0
      domainLookupEnd: 0
      domainLookupStart: 0
      redirectEnd: 0
      duration: 9.85600001877174
      redirectStart: 0
      connectEnd: 0
      connectStart: 0
      requestStart: 0
      secureConnectionStart: 0
      name: 'http://pixel.quantserve.com/pixel.png'
      startTime: 1270.19499999005
      fetchStart: 1270.19499999005
      initiatorType: 'img'
    ,
      entryType: 'resource'
      responseEnd: 1275.0003905
      responseStart: 0
      domainLookupEnd: 0
      domainLookupStart: 0
      redirectEnd: 0
      duration: 9.85600001877174
      redirectStart: 0
      connectEnd: 0
      connectStart: 0
      requestStart: 0
      secureConnectionStart: 0
      name: 'http://pixel.quantserve.com/pixel2.png'
      startTime: 1270.19499999005
      fetchStart: 1270.19499999005
      initiatorType: 'img'
    ,
      entryType: 'resource'
      responseEnd: 501.143000001321
      responseStart: 498.794999992242
      domainLookupEnd: 491.225000005215
      domainLookupStart: 489.211999985855
      redirectEnd: 0
      duration: 14.1010000079405
      redirectStart: 0
      connectEnd: 493.201000004774
      connectStart: 491.225000005215
      requestStart: 493.270000006305
      secureConnectionStart: 0
      name: 'http://cdn.optimizely.com/js/582120801.js'
      startTime: 487.04199999338
      fetchStart: 487.04199999338
      initiatorType: 'script'
    ,
      entryType: 'resource'
      responseEnd: 974.58199999528
      responseStart: 0
      domainLookupEnd: 0
      domainLookupStart: 0
      redirectEnd: 0
      duration: 505.183000001125
      redirectStart: 0
      connectEnd: 0
      connectStart: 0
      requestStart: 0
      secureConnectionStart: 0
      name: 'http://dc8hdnsmzapvm.cloudfront.net/assets/images/home/circle-icon-3.png?50d12bbb5b8be8880348422b56586c03'
      startTime: 469.398999994155
      fetchStart: 469.398999994155
      initiatorType: 'img'
    ]
