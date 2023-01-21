#!/bin/bash -e

(\
  cd "toolkit" || exit 1; \
  ./install.sh || exit 1; \
) && \
(\
  cd "jobs" || exit 1; \
  ./install.sh || exit 1; \
)

#(\
#  cd "tdcj_inmates" || exit 1; \
#  ./install.sh || exit 1; \
#)
