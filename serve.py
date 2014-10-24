#!/usr/bin/env python3
import os
import cherrypy
import sys

PATH = os.path.abspath(sys.argv[1])


class Root(object):
    pass

cherrypy.server.socket_port = 8000
cherrypy.server.socket_host = '::'
cherrypy.config.update({'environment': 'production'})
config = {
    '/': {
        'tools.staticdir.on': True,
        'tools.staticdir.dir': PATH,
        'tools.staticdir.index': 'index.html',
    },
}

cherrypy.quickstart(Root(), config=config)
