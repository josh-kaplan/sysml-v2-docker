from rockylinux:9

WORKDIR /tmp
COPY ./src/setup.sh setup.sh

RUN chmod +x setup.sh && ./setup.sh

# Launch jupyter lab
CMD ["jupyter", "lab", "--allow-root", "--no-browser"]