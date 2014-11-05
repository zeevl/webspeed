module.exports =
  get: ->
    now = Date.now()

    { onLoadStarted: 16,
      domContentLoaded: 1746,
      loadEventStart: 2247,
      loadEventEnd: 2401,
      resources:
       { '1': { start: 1, url: 'http://cnn.com/', end: 159, duration: 158 },
         '2':
          { start: 158,
            url: 'http://www.cnn.com/',
            end: 461,
            duration: 303 },
         '3':
          { start: 449,
            url: 'http://z.cdn.turner.com/cnn/tmpl_asset/static/www_homepage/2980/css/hplib-min.css',
            end: 482,
            duration: 33 },
         '4':
          { start: 450,
            url: 'http://z.cdn.turner.com/cnn/tmpl_asset/static/www_homepage/2980/css/elexlib-min.css',
            end: 473,
            duration: 23 },
         '5':
          { start: 450,
            url: 'http://z.cdn.turner.com/cnn/.e/js/libs/jquery-1.7.2.min.js',
            end: 512,
            duration: 62 },
         '6':
          { start: 451,
            url: 'http://z.cdn.turner.com/cnn/.e/js/libs/jquery.timeago.min.js',
            end: 481,
            duration: 30 },
         '7':
          { start: 451,
            url: 'http://z.cdn.turner.com/cnn/.e/js/libs/protoaculous.1.8.2.min.js',
            end: 529,
            duration: 78 },
         '8':
          { start: 451,
            url: 'http://z.cdn.turner.com/cnn/tmpl_asset/static/www_homepage/2980/js/hplib-min.js',
            end: 543,
            duration: 92 },
         '9':
          { start: 452,
            url: 'http://cdn.optimizely.com/js/131788053.js',
            end: 468,
            duration: 16 },
         '10':
          { start: 452,
            url: 'http://i.cdn.turner.com/cnn/macalerts/js/safaripush.js',
            end: 512,
            duration: 60 },
         '11':
          { start: 455,
            url: 'http://widgets.outbrain.com/outbrain.js',
            end: 529,
            duration: 74 },
         '12':
          { start: 457,
            url: 'http://i.cdn.turner.com/cnn/.e/widget/loader/1.0.0/load.min.js',
            end: 542,
            duration: 85 } },
      duration: 2866 }
