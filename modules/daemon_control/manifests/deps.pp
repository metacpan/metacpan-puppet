# Install dependencies for Daemon::Control.
class daemon_control::deps (
) {
    include perlbrew
    perlbrew::install_module { [
            'Daemon::Control',
        ]:
        perl => $metacpan::perl,
    }
}
