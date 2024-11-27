### Download visium dataset ###

# Download single nucleus count matrix for female mice

wget https://www.ebi.ac.uk/biostudies/files/E-MTAB-11115/5705STDY8058280_filtered_feature_bc_matrix.h5

# Download spatial count matrix and coordinates for female mice

wget https://www.ebi.ac.uk/biostudies/files/E-MTAB-11114/ST8059048_filtered_feature_bc_matrix.h5
wget https://www.ebi.ac.uk/biostudies/files/E-MTAB-11114/ST8059048_spatial.tar.gz

# Unzip spatial coordinates
tar -xvzf ST8059048_spatial.tar.gz
