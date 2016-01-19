LITERATE_TOOLS="https://github.com/vlead/literate-tools.git"
LITERATE_DIR=literate-tools
ELISP_DIR=elisp
ORG_DIR=org-templates
STYLE_DIR=style
DEST=build/
PWD=$(shell pwd)

all:  

clean-literate:
	rm -rf ${ELISP_DIR}
	rm -rf ${ORG_DIR}
	rm -rf ${STYLE_DIR}
	rm -rf src/${ORG_DIR}
	rm -rf src/${STYLE_DIR}

pull-literate-tools:
	@echo "pulling literate support code"
	echo ${PWD}
ifeq ($(wildcard elisp),)
	git clone ${LITERATE_TOOLS}
	mv ${LITERATE_DIR}/${ELISP_DIR} .
	mv ${LITERATE_DIR}/${ORG_DIR} .
	mv ${LITERATE_DIR}/${STYLE_DIR} .
	ln -s ${PWD}/${ORG_DIR}/ ${PWD}/src/${ORG_DIR}
	ln -s ${PWD}/${STYLE_DIR}/ ${PWD}/src/${STYLE_DIR}
	rm -rf ${LITERATE_DIR}
else
	@echo "Literate support code already present"
endif

all:  publish

publish: init
	emacs --script elisp/publish.el

init:	pull-literate-tools
	mkdir -p ${DEST}


server:
	python -m SimpleHTTPServer 6001

export:
	rsync -auvz ${DEST}presentation/* letshelp@devel.virtual-labs.ac.in:/var/www/2012-10-08-integration-sprint/

clean:  clean-literate
	rm -rf ${DEST}

archive:
	(cd ${DEST}; zip -r presentation.zip presentation)

export-choppell:
	rsync -avz ${DEST} pascal.iiit.ac.in:/home/choppell/public_html
