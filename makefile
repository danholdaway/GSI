SHELL=/bin/sh

#==============================================================================
#
# GSI Makefile
#
# <Usage>
#   0) Export this makefile name to a variable 'MAKE_FILE' as 
#       export MAKE_FILE = makefile
#      If this file is named neither 'makefile' nor 'Makefile' but 
#      'makeairs' for instance, then call this makefile by typing
#      'make -f makeairs' instead of 'make'.
#
#  0a) Modify the include link to either use compile.config.ibm
#      or compile.config.sgi for compilation on the ibm sp or sgi
#
#   1) To make a GSI executable file, type
#         > make  or  > make all
#
#   2) To make a GSI executable file with debug options, type
#         > make debug
#
#   3) To copy the GSI load module to installing directory, type
#         > make install
#      . Specify the directory to a variable 'INSTALL_DIR' below.
#
#   4) To crean up files created by make, type
#         > make clean
#
#
# Created by Y.Tahara in May,2002
# Edited by D.Kleist Oct. 2003
#==============================================================================

#-----------------------------------------------------------------------------
#                          -- Parent make (calls child make) --
#-----------------------------------------------------------------------------

# -----------------------------------------------------------
# Default configuration, possibily redefined in Makefile.conf
# -----------------------------------------------------------

ARCH	 = `uname -s`
SED      = sed
DASPERL  = /usr/bin/perl
COREROOT = ../../..
COREBIN  = $(COREROOT)/bin
CORELIB  = $(COREROOT)/lib
COREINC  = $(COREROOT)/include
COREETC  = $(COREROOT)/etc


# -------------
# General Rules
# -------------

CP              = /bin/cp -p
RM              = /bin/rm -f
MKDIR           = /bin/mkdir -p
AR              = ar cq
PROTEX          = protex -f # -l
ProTexMake      = protex -S # -l
LATEX           = pdflatex
DVIPS           = dvips

# Preprocessing
# -------------
_DDEBUG =
_D      = $(_DDEBUG)

# ---------
# Libraries
# ---------
LIBmpeu   = -L$(CORELIB) -lmpeu
LIBbfr    = -L$(CORELIB) -lbfr
LIBw3     = -L$(CORELIB) -lw3
LIBsp     = -L$(CORELIB) -lsp
LIBbacio  = -L$(CORELIB) -lbacio
LIBsfcio  = -L$(CORELIB) -lsfcio
LIBsigio  = -L$(CORELIB) -lsigio
LIBcrtm   = -L$(CORELIB) -lcrtm_gfsgsi
LIBtransf = -L$(CORELIB) -ltransf
LIBhermes = -L$(CORELIB) -lhermes
LIBgfio   = -L$(CORELIB) -lgfio

# --------------------------
# Default Baselibs Libraries
# --------------------------
INChdf          = -I$(BASEDIR)/$(ARCH)/include/hdf
LIBhdf          = -L$(BASEDIR)/$(ARCH)/lib  -lmfhdf -ldf -lhdfjpeg -lhdfz -lsz
LIBnetcdf       = -L$(BASEDIR)/$(ARCH)/lib -lnetcdf
LIBwrf          = -L$(BASEDIR)/$(ARCH)/lib -lwrflib
LIBwrfio_int    = -L$(BASEDIR)/$(ARCH)/lib -lwrfio_int
LIBwrfio_netcdf = -L$(BASEDIR)/$(ARCH)/lib -lwrfio_nf

# ------------------------
# Default System Libraries
# ------------------------
LIBmpi          = -lmpi
LIBsys          = 


#------------
# Include machine dependent compile & load options
#------------
include ./Makefile.conf


# -------------
# This makefile
# -------------

  MAKE_FILE = Makefile


# -----------
# Load module
# -----------

  EXE_FILE = global_gsi


# --------------------
# Installing directory
# --------------------

  INSTALL_DIR = ../bin


# --------
# Log file
# --------

  LOG_FILE = log.make.$(EXE_FILE)


# ---------------
# Call child make
# ---------------

"" :
	@$(MAKE) -f $(MAKE_FILE) all


# ------------
# Make install
# ------------

install:
	@echo
	@echo '==== INSTALL ================================================='
	@if [ -e $(INSTALL_DIR) ]; then \
	  if [ ! -d $(INSTALL_DIR) ]; then \
	    echo '### Fail to create installing directory ###' ;\
	    echo '### Stop the installation               ###' ;\
	    exit ;\
	  fi ;\
	else \
	  echo "	mkdir -p $(INSTALL_DIR)" ;\
	  mkdir -p $(INSTALL_DIR) ;\
	fi
	cp $(EXE_FILE) $(INSTALL_DIR)
	@cd $(INSTALL_DIR) ; ls -l `pwd`/$(EXE_FILE)


# ----------
# Make clean
# ----------

clean:
	@echo
	@echo '==== CLEAN ==================================================='
	- $(RM) $(EXE_FILE) *.o *.mod *.MOD *.lst *.a *.x
	- $(RM) loadmap.txt log.make.gsi_anl
	- $(MAKE) doclean


#-----------------------------------------------------------------------------
#                          -- Child make --
#-----------------------------------------------------------------------------

# ------------
# Source files
# ------------

  SRCSF90C = \
	abor1.f90 \
        adjtest.f90 \
	anberror.f90 \
	anbkerror_reg.f90 \
	anisofilter.f90 \
        antcorr_application.f90 \
	balmod.f90 \
	berror.f90 \
        bias_predictors.f90 \
	bkerror.f90 \
	bkgcov.f90 \
	bkgvar.f90 \
	bkgvar_rewgt.f90 \
	blacklist.f90 \
	calctends.f90 \
	calctends_ad.F90 \
	calctends_tl.F90 \
	calctends_no_ad.F90 \
	calctends_no_tl.F90 \
	combine_radobs.f90 \
	compact_diffs.f90 \
	compute_derived.f90 \
	compute_fact10.f90 \
	constants.f90 \
        control2model.f90 \
        control2state.f90 \
        control_vectors.f90 \
	converr.f90 \
	convinfo.f90 \
	convthin.f90 \
        cvsection.f90 \
	deter_subdomain.f90 \
	dtast.f90 \
        enorm_state.F90 \
        evaljgrad.f90 \
        evaljcdfi.F90 \
        evaljo.f90 \
        evalqlim.f90 \
	fgrid2agrid_mod.f90 \
	fill_mass_grid2.f90 \
	fill_nmm_grid2.f90 \
	fpvsx_ad.f90 \
	gengrid_vars.f90 \
	genqsat.f90 \
	genstats_gps.f90 \
        geos_pertmod.F90 \
        geos_pgcmtest.F90 \
	gesinfo.F90 \
	get_derivatives.f90 \
	get_derivatives2.f90 \
	get_semimp_mats.f90 \
	get_tend_derivs.f90 \
	getprs.f90 \
	getstvp.f90 \
	getuv.f90 \
	getvvel.f90 \
	glbsoi.F90 \
        grtest.f90 \
	grdcrd.f90 \
	grid2sub.f90 \
	gridmod.f90 \
	gscond_ad.f90 \
	gsi_4dvar.f90 \
	gsi_io.f90 \
	gsimod.F90 \
	gsisub.F90 \
	guess_grids.F90 \
	half_nmm_grid2.f90 \
        inc2guess.f90 \
	init_commvars.f90 \
        init_jcdfi.F90 \
        int3dvar.f90 \
	intall.f90 \
	intdw.f90 \
	intgps.f90 \
	intjo.f90 \
	intlimq.f90 \
	intoz.f90 \
	intpcp.f90 \
	intps.f90 \
	intpw.f90 \
	intq.f90 \
	intrad.f90 \
	intrp2a.f90 \
	intrp3oz.f90 \
	intrppx.f90 \
	intrw.f90 \
	intspd.f90 \
	intsrw.f90 \
	intsst.f90 \
	intt.f90 \
	intw.f90 \
	jcmod.f90 \
	jfunc.f90 \
	kinds.f90 \
	lagmod.f90 \
        lanczos.f90 \
	linbal.f90 \
        looplimits.f90 \
	m_berror_stats.F90 \
	m_dgeevx.F90 \
 	m_gsiBiases.F90 \
        m_stats.F90 \
        m_tick.F90 \
    missing_routines.f90 \
	mod_inmi.f90 \
	mod_strong.f90 \
	mod_vtrans.f90 \
        model_ad.F90 \
        model_tl.F90 \
        model2control.f90 \
	mp_compact_diffs_mod1.f90 \
	mp_compact_diffs_support.f90 \
	mpi_bufr_mod.F90 \
	mpimod.F90 \
        mpl_allreduce.f90 \
        mpl_bcast.f90 \
	ncepgfs_io.f90 \
	nlmsas_ad.f90 \
	normal_rh_to_q.f90 \
        obs_ferrscale.F90 \
	obs_para.f90 \
        obs_sensitivity.F90 \
        observer.F90 \
	obsmod.F90 \
	omegas_ad.f90 \
	oneobmod.F90 \
	ozinfo.f90 \
	pcgsoi.f90 \
	pcgsqrt.f90 \
	pcp_k.f90 \
	pcpinfo.f90 \
        penal.f90 \
	plib8.f90 \
	polcarf.f90 \
        prt_guess.f90 \
	precpd_ad.f90 \
	prewgt.f90 \
	prewgt_reg.f90 \
	psichi2uv_reg.f90 \
	psichi2uvt_reg.f90 \
	q_diag.f90 \
	qcmod.f90 \
	qcssmi.f90 \
        qnewton.f90 \
        qnewton3.F90 \
	radinfo.f90 \
	raflib.f90 \
	rdgrbsst.f90 \
	rdgstat_reg.f90 \
	read_airs.f90 \
	read_amsre.f90 \
	read_avhrr.f90 \
	read_avhrr_navy.f90 \
	read_bufrtovs.f90 \
	read_files.f90 \
	read_goesimg.f90 \
	read_goesndr.f90 \
	read_gps.f90 \
	read_guess.F90 \
	read_iasi.f90 \
	read_l2bufr_mod.f90 \
	read_lidar.f90 \
	read_modsbufr.f90 \
	read_obs.f90 \
	read_obsdiags.F90 \
	read_ozone.F90 \
	read_pcp.f90 \
	read_prepbufr.f90 \
	read_radar.f90 \
	read_ssmi.f90 \
	read_ssmis.f90 \
	read_superwinds.f90 \
	read_wrf_mass_files.f90 \
	read_wrf_mass_guess.F90 \
	read_wrf_nmm_files.f90 \
	read_wrf_nmm_guess.F90 \
	regional_io.f90 \
	ret_ssmis.f90 \
	retrieval_amsre.f90 \
	retrieval_mi.f90 \
	rfdpar.f90 \
	rsearch.F90 \
	satthin.F90 \
        setupbend.f90 \
	setupdw.f90 \
        setupo3lv.f90 \
	setupoz.f90 \
	setuppcp.f90 \
	setupps.f90 \
	setuppw.f90 \
	setupq.f90 \
	setuprad.f90 \
	setupref.f90 \
	setuprhsall.f90 \
	setuprw.f90 \
	setupspd.f90 \
	setupsrw.f90 \
	setupsst.f90 \
	setupt.f90 \
	setupw.f90 \
	setupyobs.f90 \
	sfc_model.f90 \
	simpin1.f90 \
	simpin1_init.f90 \
	smooth_polcarf.f90 \
	smoothrf.f90 \
	smoothwwrf.f90 \
	smoothzrf.f90 \
	specmod.f90 \
	spectral_transforms.f90 \
        sqrtmin.f90 \
	sst_retrieval.f90 \
        state2control.f90 \
        state_vectors.f90 \
	statsconv.f90 \
	statsoz.f90 \
	statspcp.f90 \
	statsrad.f90 \
	stop1.f90 \
	stp3dvar.f90 \
	stpcalc.f90 \
	stpdw.f90 \
	stpgps.f90 \
	stpjc.f90 \
	stpjo.f90 \
	stplimq.f90 \
	stpoz.f90 \
	stppcp.f90 \
	stpps.f90 \
	stppw.f90 \
	stpq.f90 \
	stprad.f90 \
	stprw.f90 \
	stpspd.f90 \
	stpsrw.f90 \
	stpsst.f90 \
	stpt.f90 \
	stpw.f90 \
	strong_bal_correction.f90 \
	strong_baldiag_inc.f90 \
	strong_fast_global_mod.f90 \
	strong_slow_global_mod.f90 \
	stvp2uv_reg.f90 \
	sub2grid.f90 \
	support_2dvar.f90 \
	tendsmod.f90 \
        test_obsens.F90 \
        timermod.F90 \
	tintrp2a.f90 \
	tintrp3.f90 \
	tpause.f90 \
	tpause_t.F90 \
	transform.f90 \
	tstvp2uv_reg.f90 \
	turbl.f90 \
	turbl_ad.f90 \
	turbl_tl.f90 \
	turblmod.f90 \
	tv_to_tsen.f90 \
	unfill_mass_grid2.f90 \
	unfill_nmm_grid2.f90 \
	unhalf_nmm_grid2.f90 \
	update_guess.f90 \
	update_geswtend.f90 \
	wrf_binary_interface.F90 \
	wrf_netcdf_interface.F90 \
	write_all.F90 \
	write_bkgvars_grid.f90 \
        write_obsdiags.F90 \
	wrwrfmassa.F90 \
	wrwrfnmma.F90 \
        xhat_vordivmod.f90 \
	zrnmi_mod.f90

  GSIGC_SRCS = # GSI_GridCompMod.F90

  SRCSF77 =

  SRCSC = blockIO.c

  SRCS = $(SRCSF90C) $(GSIGC_SRCS) $(SRCSF77) $(SRCSC) $(XSRCSC)

  DOCSRCS = *.f90 *.F90

# ------------
# Object files
# ------------

  SRCSF90	= ${SRCSF90C:.F90=.f90}

  OBJS 		= ${SRCSF90:.f90=.o} ${SRCSF77:.f=.o} ${SRCSC:.c=.o}


# -----------------------
# Default compiling rules
# -----------------------

.SUFFIXES :
.SUFFIXES : .F90 .f90 .f .c .o

.F90.o  :
	@echo
	@echo '---> Compiling $<'
	$(CF) $(FFLAGS) $(_D) -c $<

.f90.o  :
	@echo
	@echo '---> Compiling $<'
	$(CF) $(FFLAGS) -c $<

.f.o  :
	@echo
	@echo '---> Compiling $<'
	$(CF) $(FFLAGS_f) -c $<

.c.o  :
	@echo
	@echo '---> Compiling $<'
	$(CC) $(CFLAGS) -c $<


# ------------
# Dependencies
# ------------
include Makefile.dependency

# ----

$(EXE_FILE) : $(OBJS) gsimain.o
	$(LD) $(LDFLAGS) -o $@ gsimain.o $(OBJS) $(LIBS)


# ------------------------
# Call compiler and linker
# ------------------------

all :
	@$(MAKE) -f $(MAKE_FILE) "COMP_MODE=$@" check_mode
	@echo
	@echo '==== COMPILE ================================================='
	@$(MAKE) -f $(MAKE_FILE) \
		"FFLAGS=$(FFLAGS_N)" \
		"CFLAGS=$(CFLAGS_N)" \
		$(OBJS) gsimain.o
	@echo
	@echo '==== LINK ===================================================='
	@$(MAKE) -f $(MAKE_FILE) \
		"LIBS=$(LIBS_N)" "LDFLAGS=$(LDFLAGS_N)" \
		$(EXE_FILE)

debug :
	@$(MAKE) -f $(MAKE_FILE) "COMP_MODE=$@" check_mode
	@echo
	@echo '==== COMPILE ================================================='
	@$(MAKE) -f $(MAKE_FILE) \
		"FFLAGS=$(FFLAGS_D)" \
		"CFLAGS=$(CFLAGS_D)" \
		$(OBJS) gsimain.o
	@echo
	@echo '==== LINK ===================================================='
	@$(MAKE) -f $(MAKE_FILE) \
		"LIBS=$(LIBS_D)" "LDFLAGS=$(LDFLAGS_D)" \
		$(EXE_FILE)

check_mode :
	@if [ -e $(LOG_FILE) ]; then \
	  if [ '$(COMP_MODE)' != `head -n 1 $(LOG_FILE)` ]; then \
	    echo ;\
	    echo "### COMPILE MODE WAS CHANGED ###" ;\
	    make clean ;\
	  fi ;\
	else \
	  echo ;\
	  echo "### NO LOG FILE ###" ;\
	  make clean ;\
	fi
	@echo $(COMP_MODE) > $(LOG_FILE)

# -------------------------
# GMAO Nomenclature/targets
# -------------------------
LIB =   libgsi.a

lib: $(LIB)

gsi.x:  $(OBJS) $(LIB) gsimain.o
	$(FC) $(LDFLAGS) -o gsi.x gsimain.o libgsi.a $(LIBcrtm) $(LIBsfcio) $(LIBsigio) $(LIBw3) $(LIBbacio) $(LIBbfr) $(LIBsp) $(LIBtransf) $(LIBhermes) $(LIBmpeu) $(LIBgfio) $(LIBhdf) $(LIBmpi) $(LIBsys)

prepbykx.x: prepbykx.o
	$(FC) $(LDFLAGS) -o prepbykx.x prepbykx.o $(LIBbfr)

$(LIB): $(OBJS)
	$(RM) $(LIB)
	$(AR) $@ $(OBJS)

export: libgsi.a gsi.x prepbykx.x
	$(MKDIR)               $(COREBIN)
	$(CP) $(LIB)           $(CORELIB)
	$(CP) gsi.x            $(COREBIN)
	$(CP) gsi.rc.sample    $(COREETC)/gsi.rc
	$(CP) tlmadj_parameter.rc.sample $(COREETC)/tlmadj_parameter.rc
	$(CP) gmao_airs_bufr.tbl       $(COREETC)/gmao_airs_bufr.tbl
	$(CP) gmao_global_pcpinfo.txt  $(COREETC)/gmao_global_pcpinfo.rc
	$(CP) gmao_global_satinfo.txt  $(COREETC)/gmao_global_satinfo.rc
	$(CP) gmao_global_ozinfo.txt   $(COREETC)/gmao_global_ozinfo.rc
	$(CP) gmao_global_convinfo.txt $(COREETC)/gmao_global_convinfo.rc
	$(SED) -e "s^@DASPERL^$(DASPERL)^" < analyzer > $(COREBIN)/analyzer
	chmod 755 $(COREBIN)/analyzer

doc:              AnIntro $(DOCSRC)
	$(PROTEX) AnIntro *.f90 *.F90 >  gsi.tex
	$(LATEX) gsi.tex
	$(LATEX) gsi.tex

doclean:
	- $(RM) *.tex *.dvi *.aux *.toc *.log *.ps *.pdf

help:
	@ echo "Available targets:"
	@ echo "NCEP:  make             creates gsi executable        "
	@ echo "NPEP:  make debug       created gsi exec for debugging purposes"
	@ echo "NCEP:  make install     creates gsi exec & places it in bin"
	@ echo "GMAO:  make lib         creates gsi library"
	@ echo "GMAO:  make export      creates lib, exec, & copies all to bin/inc/etc"
	@ echo "       make clean       cleans objects, exec, and alien files"  
	@ echo "       make doc         creates documentation"
	@ echo "       make doclean     clean doc-related temporary files"
