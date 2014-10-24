FROM hjacobs/nikola

# CherryPy is used to serve the static HTML (not optimal, I know)
RUN pip3 install CherryPy==3.6.0

# the main Bash loop
ADD run.sh /

# the CherryPy server app
ADD serve.py /

# the Pequod application manifest
ADD pequod.xml /

EXPOSE 8000

ENTRYPOINT ["/run.sh"]
