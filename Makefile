
BINARY_NAME = slide-archiver
SOURCES = $(wildcard *.vala)
VALAC = valac-0.24

PACKAGES = gee-0.8 sane-backends vala-scan
VALA_PKG_ARGS = $(foreach pkg, $(PACKAGES), --pkg $(pkg))

all: $(BINARY_NAME)

$(BINARY_NAME): $(SOURCES)
	$(VALAC) $(VALA_PKG_ARGS) $(SOURCES) -o $(BINARY_NAME)
