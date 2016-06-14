# == Class: minion_queue
#
# Add the following to hiera
#
# classes:
#    - minion_queue
#
# minion_queue::service::workers: 1
# minion_queue::service::ensure: running
# minion_queue::service::enable: true
#
#
class minion_queue(
) {

  include minion_queue::service

}
