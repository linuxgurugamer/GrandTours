# Makefile

# Name of text file containing version number.
VERSION_NUMBER_FILE=version-number.txt

# Name of text file containing build number.
BUILD_NUMBER_FILE=build-number.txt

# Name of text file containing patch number.
PATCH_NUMBER_FILE=patch-number.txt

MODDIR=GameData/ContractPacks/spacetux
INSTALLDIR=~/install

OBJECTS=GrandTour.version License.txt CHANGELOG-GrandTour all_planets.grandtour.cfg   inner_planets.grandtour.cfg   outer_planets.grandtour.cfg all_planets.land.grandtour.cfg   inner_planets.land.grandtour.cfg  outer_planets.land.grandtour.cfg all_planets_and_moons.grandtour.cfg  inner_planets_and_moons.grandtour.cfg  outer_planets_with_moons.grandtour.cfg all_planets_and_moons.land.grandtour.cfg inner_planets_and_moons.land.grandtour.cfg outer_planets_with_moons.land.grandtour.cfg


help:
	@echo "Grand Tour build commands:"
	@echo "make install         Copy release files to install directory"
	@echo "make release         Build a new tarfile, and update patch number"
	@echo "make version         Increment the version and set build to 0"
	@echo "make nopatchrelease  Create the zip file, but not update patch number"
	@echo "make mono            Test the netkan file against uploaded file"
	@echo "make clean           Delete all unnecessary files"

build:
	./buildtours.sh 

install:	$(OBJECTS)
	@rm -fr $(INSTALLDIR)/$(MODDIR)/*
	@mkdir -p $(INSTALLDIR)/$(MODDIR)
	@cp $(OBJECTS) $(INSTALLDIR)/$(MODDIR)

release:
	./update.sh $(MODDIR)

version:	$(VERSION_NUMBER_FILE) release
	
# Version number file.  Increment if requested
$(VERSION_NUMBER_FILE):	nullfile
	@if ! test -f $(VERSION_NUMBER_FILE); then echo 0 > $(VERSION_NUMBER_FILE); fi
	@echo $$(($$(cat $(VERSION_NUMBER_FILE)) + 1)) > $(VERSION_NUMBER_FILE)
	@echo -1 > $(BUILD_NUMBER_FILE)

nullfile:

# Build number file.  Increment if any object file changes.
$(BUILD_NUMBER_FILE): $(OBJECTS)
	@if ! test -f $(BUILD_NUMBER_FILE); then echo 0 > $(BUILD_NUMBER_FILE); fi
	@echo $$(($$(cat $(BUILD_NUMBER_FILE)) + 1)) > $(BUILD_NUMBER_FILE)

GrandTour.version:
	./update.sh GrandTour version

mono:
	./update.sh GrandTour mono

clean:
	rm -f *.cfg

