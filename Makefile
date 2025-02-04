MODULE_big = pg_failover_slots
OBJS = pg_failover_slots.o

PG_CPPFLAGS += -I $(libpq_srcdir)
SHLIB_LINK += $(libpq)

TAP_TESTS = 1

PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)

prove_installcheck: $(pgxsdir)/src/test/perl/$(core_perl_module)
	rm -rf $(CURDIR)/tmp_check
	mkdir -p $(CURDIR)/tmp_check &&\
		PERL5LIB="$${PERL5LIB}:$(srcdir)/t:$(pgxsdir)/src/test/perl" \
		PG_VERSION_NUM='$(VERSION_NUM)' \
		TESTDIR='$(CURDIR)' \
		SRCDIR='$(srcdir)' \
		PATH="$(TEST_PATH_PREFIX):$(PATH)" \
		PGPORT='6$(DEF_PGPORT)' \
		top_builddir='$(CURDIR)/tmp_check' \
		PG_REGRESS='$(pgxsdir)/src/test/regress/pg_regress' \
		PGCTLTIMEOUT=180 \
		$(PROVE) $(PG_PROVE_FLAGS) $(PROVE_FLAGS) \
		$(addprefix $(srcdir)/,$(or $(PROVE_TESTS),t/*.pl))

check_prove: prove_installcheck
