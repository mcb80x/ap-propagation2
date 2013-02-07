.PHONY: svg dir css swf audio

JADE_FILES=${wildcard *.jade}
COFFEE_FILES=${wildcard scripts/*.coffee}
CSS_FILES=${wildcard css/*.css}
SVG_FILES=${wildcard art/*.svg}

all: html js svg css swf audio

css: ${CSS_FILES}
	mkdir -p www/css
	cp -r css/* www/css/
	cp -r common/css/* www/css

html: ${JADE_FILES}
	jade --out www/ .

audio:
	mkdir -p www/audio
	cp audio/* www/audio/

dir:
	mkdir -p www/js

js: ${COFFEE_FILES} dir
	toaster -d -c

svg:
	mkdir -p www/svg
	cp art/*.* www/svg/

swf:
	mkdir -p www/swf
	cp common/third-party/swf/* www/swf/

serve: all
	cd www; python -m SimpleHTTPServer 8080