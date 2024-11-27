# Download Visium dataset

# Create the directory if it does not exist
mkdir -p data/Visium/input

# Download single nucleus count matrix for female mice
wget -P data/Visium/input https://www.ebi.ac.uk/biostudies/files/E-MTAB-11115/5705STDY8058280_filtered_feature_bc_matrix.h5

# Download spatial count matrix and coordinates for female mice
wget -P data/Visium/input https://www.ebi.ac.uk/biostudies/files/E-MTAB-11114/ST8059048_filtered_feature_bc_matrix.h5
wget -P data/Visium/input https://www.ebi.ac.uk/biostudies/files/E-MTAB-11114/ST8059048_spatial.tar.gz

# Navigate to the input directory
cd data/Visium/input || exit

# Extract the spatial data
tar -xvzf ST8059048_spatial.tar.gz

echo "Download Visium dataset completed"
