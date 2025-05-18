# Measurement of carbon emissions

## cloud energy

See [https://github.com/green-coding-solutions/cloud-energy](https://github.com/green-coding-solutions/cloud-energy)

### Connect to VM

``` cmd
ssh -i ./.ssh/cloud-energy.pem azureuser@4.219.2.105
```

### Setup cloud energy

``` bash
cd cloud-energy
python3 -m venv venv
source venv/bin/activate
pip3 install -r requirements.txt
```

### Setup stress &  sysstat

``` bash
sudo apt-get install stress
sudo apt install sysstat
```

### run

> monitor

``` bash
sar -u 3
 ```

> stress

``` bash
stress -c 1 -i 2 -m 4
 ```

> measure

``` bash
python3 xgb.py --auto --autoinput
```