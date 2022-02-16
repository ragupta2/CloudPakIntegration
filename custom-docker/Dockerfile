FROM cp.icr.io/cp/ibm-mqadvanced-server-integration:9.2.4.0-r1
COPY BlockIP2 /opt/mqm/exits/BlockIP2
COPY blockip2 /opt/mqm

# USER 0
# WORKDIR /opt/mqm/exits/
# RUN chown -R 1001:0 /opt/mqm/exits/
# COPY --chown=1001:0 BlockIP2 /opt/mqm/exits/BlockIP2
# COPY --chown=1001:0 blockip2.txt /opt/mqm/exits
# COPY --chown=1001:0 test.sh /opt/mqm/exits
# USER 1001
