# Build image
FROM balenalib/%%BALENA_MACHINE_NAME%%-alpine:latest-build as build
# Work in /tmp directory
WORKDIR /tmp
# Copy all files to the work directory
COPY . ./
# Build the code
RUN make all USE_SYSTEMD=0 USE_BALENA=1 PREFIX=/usr

# Runtime image without build tools
FROM balenalib/%%BALENA_MACHINE_NAME%%-alpine:latest-run
# Install the files
COPY --from=build /tmp/build/liblifepo4wered.so /usr/lib/liblifepo4wered.so
COPY --from=build /tmp/build/lifepo4wered-cli /usr/bin/lifepo4wered-cli
COPY --from=build /tmp/build/lifepo4wered-daemon /usr/sbin/lifepo4wered-daemon

# Load the I2C device driver and run the deamon
CMD lifepo4wered-daemon -f
