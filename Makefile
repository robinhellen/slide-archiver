
BINARY_NAME = slide-archiver
SOURCES = $(wildcard *.vala) $(wildcard ui/*.vala)
VALAC = valac-0.26

LOCAL_PACKAGES= sane-backends vala-scan diva
LOCAL_LIBS= vala-scan diva
PACKAGES = gee-0.8 gdk-3.0 gtk+-3.0 $(LOCAL_PACKAGES)
VALA_PKG_ARGS = $(foreach pkg, $(PACKAGES), --pkg $(pkg))
VALA_OPTS = --vapidir=vapi -g
C_OPTS = -Ih -g -w $(foreach lib, $(LOCAL_LIBS), lib/$(lib).so)

all: $(BINARY_NAME)

$(BINARY_NAME): $(SOURCES) $(foreach pkg, $(LOCAL_PACKAGES), vapi/$(pkg).vapi) $(foreach lib, $(LOCAL_LIBS), h/$(lib).h lib/$(lib).so)
	$(VALAC) $(VALA_OPTS) $(VALA_PKG_ARGS) $(SOURCES) -o $(BINARY_NAME) $(foreach opt, $(C_OPTS), -X $(opt))

# Recursively make dependencies, and copy into local dirs
vapi/sane-backends.vapi: sane-backend-vapi/sane-backends.vapi
	mkdir -p vapi
	cp sane-backend-vapi/sane-backends.vapi vapi/

vapi/vala-scan.vapi: vala-scan/vala-scan.vapi
	mkdir -p vapi
	cp vala-scan/vala-scan.vapi vapi/
h/vala-scan.h: vala-scan/vala-scan.h
	mkdir -p h
	cp vala-scan/vala-scan.h h/
lib/vala-scan.so: vala-scan/vala-scan.so
	mkdir -p lib
	cp vala-scan/vala-scan.so lib/

vapi/diva.vapi: diva/diva.vapi
	mkdir -p vapi
	cp diva/diva.vapi vapi/
h/diva.h: diva/diva.h
	mkdir -p h
	cp diva/diva.h h/
lib/diva.so: diva/diva.so
	mkdir -p lib
	cp diva/diva.so lib/


vala-scan/vala-scan.vapi vala-scan/vala-scan.so vala-scan/vala-scan.h:
	$(MAKE) -C vala-scan
diva/diva.vapi diva/diva.so diva/diva.h:
	$(MAKE) -C diva

