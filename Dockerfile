FROM base/archlinux

# RUN pacman --noconfirm -Syyu && \
#     pacman --noconfirm -S ansible && \
#     adduser monkey
#     ADD MONKEY AS SUDO USER

ADD . /usr/src/ansible-provisioner/
# WORKDIR /usr/src/ansible-provisioner
# RUN make run-arch

# WORKDIR /home/monkey
# USER monkey
CMD /bin/bash
