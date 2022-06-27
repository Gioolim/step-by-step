pragma solidity ^0.5.8:

contract Lottery{
    address public manager;    // 관리자 변수 manager 선언
   //address public payable players[];
   address payable[] public players;

    constructor() public{      // 배포할 때 1번만 실행되는 생성자 함수
        manager = msg.sender;  // manager는 컨트랙트를 생성하는 사람의 주소
    }

    function enter() public payable{
        require(msg.value >= 0.1 ether) 
        // 컨트랙트에 담아 보낸 이더 값이 0.1 ether 이상인지 아닌지 확인
        players.push(msg.sender);
    }

    function random() private view returns (uint){
        return uint(keccak25(abi.encodePacked(now, msg.sender, players.length)));
        // 해시 알고리즘. now는 현재 시간 의미. 난수 생성 함수
    }

    function pickWinner() public restricted{
        // restricted : 처음보는 함수일 경우 modifier 가능성 의심
        // uint형 변수 index에는 random() 함수의 return 값을 players.length로 나눈 나머지
        uint index = random() % players.length
        players[index].transfer(address(this).balance);
        // enter() 했을 때 돈이 address(this).balance 에 모인다.
    }

    function getPlayers() public view returns (address[]){
        return players;
    }

    modifier restricted{
        require(manager == msg.sender) // manager가 함수를 호출한 사람이 맞는지 확인
                                       // -> manager만 실행할 수 있는 함수이다.
        _;                             // 맞으면 다시 pickWinner 함수로 돌아가 나머지 코드 수행
    }

}
