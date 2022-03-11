// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Share {

  Show [] private shows;
  ShowDomain [] private showDomains;
  ShowTunnel [] private showTunnels;
  address owner;

  struct Show{    // 恶意IP/域名结构体
      string IP;  // 恶意ip
      string Level;  // 风险等级
      string IocType;  // ioc类型  
      string Tags;  // 标签
      string WarnName; // 类型名称
      string Country;  //恶意IP所在国家
      string City; //恶意IP所在城市
      string ISP; //恶意IP使用的服务代理商
  }

  struct ShowDomain{    // 恶意IP/域名结构体
      string Domain;  // 恶意域名
      string Level;  // 风险等级
      string IocType;  // ioc类型  
      string Tags;  // 标签
      string WarnName; // 类型名称
      string Country;  //恶意IP所在国家
      string City; //恶意IP所在城市
      string ISP; //恶意IP使用的服务代理商
  }

  struct ShowTunnel{    // 恶意IP/域名结构体
      string IP;  // 恶意ip
      string Level;  // 风险等级
      string IocType;  // ioc类型  
      string Tags;  // 标签
      string WarnName; // 类型名称
      string Country;  //恶意IP所在国家
      string City; //恶意IP所在城市
      string ISP; //恶意IP使用的服务代理商
  }

  function upload(string memory ip,string memory level,string memory iocType,string memory tags,string memory warnName,string memory country,string memory city,string memory isp) private {
    shows.push(Show(ip,level,iocType,tags,warnName,country,city,isp));
  }

  function uploadDomain(string memory domain,string memory level,string memory iocType,string memory tags,string memory warnName,string memory country,string memory city,string memory isp) private {
    showDomains.push(ShowDomain(domain,level,iocType,tags,warnName,country,city,isp));
  }

  function uploadTunnel(string memory ip,string memory level,string memory iocType,string memory tags,string memory warnName,string memory country,string memory city,string memory isp) private {
    showTunnels.push(ShowTunnel(ip,level,iocType,tags,warnName,country,city,isp));
  }

  function store(string[][] memory _shows) public {
    // require(owner == msg.sender, 'must be onwer');
    for (uint256 i = 0; i < _shows.length; i++) {
      upload(_shows[i][0],_shows[i][1],_shows[i][2],_shows[i][3],_shows[i][4],_shows[i][5],_shows[i][6],_shows[i][7]);
    }
  }

  function storeDomain(string[][] memory _showDomains) public {
    // require(owner == msg.sender, 'must be onwer');
    for (uint256 i = 0; i < _showDomains.length; i++) {
      uploadDomain(_showDomains[i][0],_showDomains[i][1],_showDomains[i][2],_showDomains[i][3],_showDomains[i][4],_showDomains[i][5],_showDomains[i][6],_showDomains[i][7]);
    }
  }

  function storeTunnel(string[][] memory _showsTunnels) public {
    // require(owner == msg.sender, 'must be onwer');
    for (uint256 i = 0; i < _showsTunnels.length; i++) {
      uploadTunnel(_showsTunnels[i][0],_showsTunnels[i][1],_showsTunnels[i][2],_showsTunnels[i][3],_showsTunnels[i][4],_showsTunnels[i][5],_showsTunnels[i][6],_showsTunnels[i][7]);
    }
  }

  //提取出来
  function query() view public returns(Show[] memory) {
    return shows;
  }

  function queryDomain() view public returns(ShowDomain[] memory) {
    return showDomains;
  }

  function queryTunnel() view public returns(ShowTunnel[] memory) {
    return showTunnels;
  }
}
