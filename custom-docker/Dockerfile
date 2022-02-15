# FROM registry.access.redhat.com/ubi8/perl-526 as builder1


FROM cp.icr.io/cp/ibm-mqadvanced-server-integration:9.2.4.0-r1
# RUN curl https://www.cpan.org/src/5.0/perl-5.34.0.tar.gz --output perl.tar.gz
# RUN tar -xzvf perl.tar.gz
# curl https://ftp.gnu.org/gnu/gcc/gcc-4.9.3/gcc-4.9.3.tar.gz

# COPY --from=builder1 /usr/bin /usr/bin
# COPY --from=builder1 /usr/lib64 /usr/lib64

USER 0
WORKDIR /opt/mqm/exits/
RUN chown -R 1001:0 /opt/mqm/exits/
COPY --chown=1001:0 BlockIP2 /opt/mqm/exits/BlockIP2
COPY --chown=1001:0 blockip2.txt /opt/mqm/exits
COPY --chown=1001:0 test.sh /opt/mqm/exits
USER 1001
