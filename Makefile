
BINARY_NAME = slide-archiver
SOURCES = $(wildcard *.vala)
VALAC = valac-0.24

LOCAL_PACKAGES= sane-backends vala-scan
LOCAL_LIBS= vala-scan
PACKAGES = gee-0.8 $(LOCAL_PACKAGES)
VALA_PKG_ARGS = $(foreach pkg, $(PACKAGES), --pkg $(pkg))
VALA_OPTS = --vapidir=vapi
C_OPTS = -Ih -g $(foreach lib, $(LOCAL_LIBS), lib/$(lib).so)

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

vala-scan/vala-scan.vapi vala-scan/vala-scan.so vala-scan/vala-scan.h:
	$(MAKE) -C vala-scan

