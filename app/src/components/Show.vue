<template>
  <div class="hello">
    <h1>{{ msg }}</h1>
    <ul>
      <li> <button @click="showIP">展示恶意IP信息(源地址)</button> </li>
      <li> <button @click="showDomain">展示恶意域名信息(隧道目的地址)</button> </li>
      <li> <button @click="showTunnel">展示恶意IP信息(隧道目的地址)</button> </li>
    
      <div class="ip" v-show="ip">
        <div class="ipInfo" v-for="ip in ips" :key="ip.IP">
          <span><strong>IP地址:</strong>{{ip.IP}}</span><br>
          <span><strong>风险等级:</strong>{{ip.Level}}</span><br>
          <span><strong>类型:</strong>{{ip.IocType}}</span><br>
          <span><strong>恶意标签:</strong>{{ip.Tags}}</span><br>
          <span><strong>威胁类型名:</strong>{{ip.WarnName}}</span><br>
          <span><strong>国家:</strong>{{ip.Country}}</span><br>
          <span><strong>城市/地区:</strong>{{ip.City}}</span><br>
          <span><strong>服务代理商:</strong>{{ip.ISP}}</span><br>
        </div>
      </div>
      <div class="domain" v-show="domain">
        <div class="domainInfo" v-for="domain in domains" :key="domain.Domain">
          <span><strong>域名地址:</strong>{{domain.Domain}}</span><br>
          <span><strong>风险等级:</strong>{{domain.Level}}</span><br>
          <span><strong>类型:</strong>{{domain.IocType}}</span><br>
          <span><strong>恶意标签:</strong>{{domain.Tags}}</span><br>
          <span><strong>威胁类型名:</strong>{{domain.WarnName}}</span><br>
          <span><strong>国家:</strong>{{domain.Country}}</span><br>
          <span><strong>城市/地区:</strong>{{domain.City}}</span><br>
          <span><strong>服务代理商:</strong>{{domain.ISP}}</span><br>
        </div>
      </div>
      <div class="tunnel" v-show="tunnel">
        <div class="tunnelInfo" v-for="tunnel in tunnels" :key="tunnel.IP">
          <span><strong>IP地址:</strong>{{tunnel.IP}}</span><br>
          <span><strong>风险等级:</strong>{{tunnel.Level}}</span><br>
          <span><strong>类型:</strong>{{tunnel.IocType}}</span><br>
          <span><strong>恶意标签:</strong>{{tunnel.Tags}}</span><br>
          <span><strong>威胁类型名:</strong>{{tunnel.WarnName}}</span><br>
           <span><strong>国家:</strong>{{tunnel.Country}}</span><br>
          <span><strong>城市/地区:</strong>{{tunnel.City}}</span><br>
          <span><strong>服务代理商:</strong>{{tunnel.ISP}}</span><br>
        </div>
      </div>
    </ul>
  </div>
</template>

<script>
import ipArray from '../assets/ips.json';
import domainArray from '../assets/domain.json'
import tunnelArrray from '../assets/ipTunnel.json'
import showContract from '../../../build/contracts/Share.json';
import Web3 from "web3";

export default {
  name: 'ShowInfo',
  props: {
    msg: String
  },
  data() {
    return {
      ip: false,
      domain: false,
      tunnel: false,
      ips: [],
      domains: [],
      tunnels: []
    }
  },
  // init 
  mounted() {
    const instance = this;
    const App = {
      web3: null,
      account: null,
      meta: null,

      start: async function() {
        const { web3 } = this;

        try {
          // get contract instance
          const networkId = await web3.eth.net.getId();
          const deployedNetwork = showContract.networks[networkId];
          this.meta = new web3.eth.Contract(
            showContract.abi,
            deployedNetwork.address,
          );

          // get accounts
          const accounts = await web3.eth.getAccounts();
          this.account = accounts[0];
          // console.log('this.account=>',this.account);

          this.storeIps();
          this.storeDomains();
          this.storeTunnels();
        } catch (error) {
          console.error("Could not connect to contract or chain.");
        }
      },

      storeIps: async function() {
        const { store } = this.meta.methods;
        const ips = ipArray.map(item=>(
          [item.ip,item.risk_level.toString(),item.ioc_type,item.tags_en.toString(),item.warn_name,item.country,item.city,item.isp]
        ))
        console.log(ips);
        await store(ips).send({from:this.account})

        // console.log('ipArray=>',ipArray);
        this.queryIps();
      },

      storeDomains: async function() {
        const { storeDomain } = this.meta.methods;
        const domains = domainArray.map(item=>(
          [item.domain,item.risk_level.toString(),item.ioc_type,item.tags_en.toString(),item.warn_name,item.country,item.city,item.isp]
        ))
        console.log(domains);
        await storeDomain(domains).send({from:this.account})

        // console.log('domainArray=>',domainArray);
        this.queryDomains();
      },

      storeTunnels: async function() {
        const { storeTunnel } = this.meta.methods;
        const tunnels = tunnelArrray.map(item=>(
          [item.ip,item.risk_level.toString(),item.ioc_type,item.tags_en.toString(),item.warn_name,item.country,item.city,item.isp]
        ))
        console.log(tunnels);
        await storeTunnel(tunnels).send({from:this.account})

        console.log('tunnelArrray=>',tunnelArrray);
        this.queryTunnels();
      },

      queryIps: async function() {
        const { query } = this.meta.methods;
        const getQuery = await query().call();
        console.log("getQuery=>",getQuery)
        instance.ips = getQuery.map(item=>({
          IP: item[0],
          Level: item[1],
          IocType: item[2],
          Tags: item[3],
          WarnName: item[4],
          Country: item[5],
          City: item[6],
          ISP: item[7]
        }))
      },

      queryDomains: async function() {
        const { queryDomain } = this.meta.methods;
        const getQueryDomain = await queryDomain().call();
        console.log("getQueryDomain=>",getQueryDomain)
        instance.domains = getQueryDomain.map(item=>({
          Domain: item[0],
          Level: item[1],
          IocType: item[2],
          Tags: item[3],
          WarnName: item[4],
          Country: item[5],
          City: item[6],
          ISP: item[7]
        }))
      },

      queryTunnels: async function() {
        const { queryTunnel } = this.meta.methods;
        const getQueryTunnel = await queryTunnel().call();
        console.log("getQueryTunnel=>",getQueryTunnel)
        instance.tunnels = getQueryTunnel.map(item=>({
          IP: item[0],
          Level: item[1],
          IocType: item[2],
          Tags: item[3],
          WarnName: item[4],
          Country: item[5],
          City: item[6],
          ISP: item[7]
        }))
      },
    };
    App.web3 = new Web3(window.ethereum);
    window.ethereum.enable(); 
    // App.web3 = new Web3(
    //     new Web3.providers.HttpProvider("http://127.0.0.1:7545"),
    // );
    App.start();

  },
  methods: {
    showIP() {
      this.ip = true; 
      this.domain = false;
      this.tunnel = false;
    },
    showDomain() {
      this.domain = true;
      this.ip = false;
      this.tunnel = false;
    },
    showTunnel() {
      this.tunnel = true;
      this.ip = false;
      this.domain = false;
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h3 {
  margin: 40px 0 0;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
.ipInfo {
  /* border-style:solid;
  border-width:2px; */
  padding: 1%;
  height: 180px;
  width: 400px;
  margin: auto;
}
.domainInfo {
  /* border-style:solid;
  border-width:2px; */
  padding: 1%;
  height: 180px;
  width: 400px;
  margin: auto;
}
.tunnelInfo {
  /* border-style:solid;
  border-width:2px; */
  padding: 1%;
  height: 180px;
  width: 400px;
  margin: auto;
}
</style>
