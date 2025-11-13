FROM odoo:18.0
 
USER root
 
# Install system dependencies for building Python packages
RUN apt-get update && apt-get install -y \
    git \
    nano \
    build-essential \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*
 
# Copy core requirements from odoo_core
COPY ./odoo_core/requirements.txt /tmp/core-requirements.txt
 
# Copy custom requirements (only pyjwt)
COPY ./test_odoo18/requirements.txt /tmp/custom-requirements.txt
 
# Install core requirements using --break-system-packages
RUN if [ -f /tmp/core-requirements.txt ]; then \
    echo "Installing core requirements..." && \
    python3 -m pip install --break-system-packages -r /tmp/core-requirements.txt; \
    fi
 
# Install custom requirements (pyjwt)
RUN if [ -f /tmp/custom-requirements.txt ]; then \
    echo "Installing custom requirements..." && \
    python3 -m pip install --break-system-packages -r /tmp/custom-requirements.txt; \
    fi
 
# Create necessary directories
RUN mkdir -p /mnt/odoo-core /mnt/base-addons /mnt/enterprise-addons /mnt/custom-addons \
    && chown -R odoo:odoo /mnt
 
USER odoo
 
EXPOSE 8069 8072
 