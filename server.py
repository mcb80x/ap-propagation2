#!/usr/bin/env python

import bottle
from bottle import route, run, template, static_file

bottle.debug(True)


@route('/')
def index():
    return static_file('index.html', root='www')


@route('/app/:script')
def script(script='approp'):
    return template('www/template.html', script=script)


@route('/app/<path:path>')
def static(path):
    print 'serving ' + path + '....'
    return static_file(path, root='www')


@route('/<path:path>')
def static2(path):
    print 'serving ' + path + '....'
    return static_file(path, root='www')

run(host='localhost', port=8080, server='cherrypy')
