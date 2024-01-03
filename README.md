# SysML 2.0 Lab

jupyter lab --ip=0.0.0.0 --port=8080 --allow-root --no-browser --LabApp.notebook_dir="/opt/sysml2/notebooks" --LabApp.password="argon2:$argon2id$v=19$m=10240,t=10,p=8$hmhzB+ERxnoxSuD4LYJoWQ$peFXmrYo4DOSPBsXRf8LnFtzGyfwdu5Cnap+qK51f8U"

Hashed password to use for web authentication.
from notebook.auth import passwd; passwd()