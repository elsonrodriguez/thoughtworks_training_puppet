import "system"
import "database"

import "variables.pp"

include apt-magic
include mysql

opencart-data-setup { "opencartdb1":
    opencart_username => $opencart_username,
    opencart_password => $opencart_password,
    opencart_database => $opencart_database,
}	

