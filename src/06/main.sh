#/bin/bash

rm report.html
goaccess ../04/log_file_*.log --log-format=COMBINED >> report.html
