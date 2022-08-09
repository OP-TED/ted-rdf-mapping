 TED-SWS artefacts
 === 
Transformation rules and other artefacts for the [TED Semantic Web Services (TED-SWS)](https://github.com/meaningfy-ws/ted-sws) system.

The artefacts provided in this repository are used as are by the TED-SWS system. They are organised in packages called Mapping Suites.

[Project documentation available here.](https://meaningfy-ws.github.io/ted-sws-artefacts/ted-sws-artefacts/index.html)  


The following table indicates the status of the various mapping suites. 

| Status        | Mapping Suites                                      | 
|----------------|-----------------------------------------------------|
| Released       |                                                     |          
 | In review      | package_F03                                         | 
| In development | package_F06, package_F25, package_F22, package_F21  |          
 | For testing    | package_F03_test, package_F03_demo                  |    


# Installation 

To assist the semantic engineers in the development of mapping suites a toolchain has been developed. The toolchain is documented on the documentation page. In order to install it open a terminal and follow the instructions below.

 1. Clone the project from GitHub 
```bash
git clone https://github.com/meaningfy-ws/ted-sws-artefacts
cd ted-sws-artefacts
```

2. Create and activate a virtual environment
```bash
python -m venv venv
source venv/bin/activate
```

3. Use makefile target to install the requirements 
```bash
make install
```

# Contributing

You are more than welcome to help expand and mature this project. 

When contributing to this repository, please first discuss the change you wish to make via issue, email, or any other method with the owners of this repository before making a change.

Please note we adhere to [Apache code of conduct](https://www.apache.org/foundation/policies/conduct), please follow it in all your interactions with the project.  

# Licence 

The documents, such as reports and specifications are licenced under a [CC BY 4.0 licence](https://creativecommons.org/licenses/by/4.0/deed.en).

The source code and other scripts are licenced under [EUPL v1.2](https://joinup.ec.europa.eu/collection/eupl/eupl-text-eupl-12) licence.
