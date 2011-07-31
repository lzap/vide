import os
from tito import builder
from tito.common import run_command, debug, find_spec_file

class AutotoolsBuilder(builder.Builder):

    def _setup_sources(self):
        """
        Create the autotools tarball using "make dist" command. Works only
        with tar.gz tarballs.

        Created in the temporary rpmbuild SOURCES directory.
        """
        self._create_build_dirs()

        debug("Creating dist tarball")
        run_command("make dist VERSION=%s" % self.display_version)
        full_path = os.path.join(self.rpmbuild_basedir, self.tgz_filename)
        debug("Moving %s to %s" % (self.tgz_filename, self.rpmbuild_sourcedir))
        run_command("mv %s %s" % (self.tgz_filename, self.rpmbuild_sourcedir))

        # Extract the source so we can get at the spec file, etc.
        debug("Copying git source to: %s" % self.rpmbuild_sourcedir)
        run_command("cd %s/ && tar xzf %s" % (self.rpmbuild_sourcedir,
            self.tgz_filename))

        self.spec_file_name = find_spec_file(in_dir=self.rpmbuild_gitcopy)
        self.spec_file = os.path.join(self.rpmbuild_gitcopy, self.spec_file_name)
