// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract escrow {
  address payable buyer;
  address payable seller;

// escrow for bussiness market
  struct Deal{
    string buyer_name;
    uint items;
    uint total;
    uint price_per_item;
    string date;
  }
  Deal public deals;

  uint balance; 
  uint start;
  uint end;

  
  // event for notification
  event nofify(string notification);
  // event for recieve function
  event AmoutRecieved(address user,uint amount);

  enum state{Payment_pending, Delivery_pending, Pending_fund_release, Complete}
  state public status;

  bool public isBuyer;
  bool public isSeller;


  constructor(address payable _seller) {
    buyer = payable(msg.sender); // buyer is deployer
    seller = _seller;
    status = state.Payment_pending;
  }

  function Product_details(string memory buyer_name,uint items_amount,string memory _date,uint price_per_product) 
  public {
    deals.buyer_name = buyer_name;
    deals.items = items_amount;
    deals.date = _date;
    deals.price_per_item = price_per_product;
    deals.total = deals.price_per_item * deals.items;
  }

    fallback()payable external {
    require(msg.sender == buyer,'Only for buyer');
    require(status==state.Payment_pending,'payement is already completed');
    require(msg.value >= deals.total,'amount is less the required amount');
    balance = msg.value;
    start = block.timestamp;
    status = state.Delivery_pending;
    emit nofify('buyer has deposited the fund in escrow');

  }
  receive() external payable{
    require(msg.sender == seller, 'wait let me inform seller Bhoi');
    require(status==state.Delivery_pending,'product is not delivered yet');
    require(msg.value >= deals.total);
    balance = seller.balance + msg.value;
    end = block.timestamp;
    status = state.Complete;
    emit AmoutRecieved(seller, msg.value);

  }
  function escrow_balance() public view returns (uint)
  {
    return address(this).balance;
  }
  function seller_deny_service() public
  {
    require(msg.sender == seller, 'you cannot hack my contract');
    require(status == state.Delivery_pending);
      buyer.transfer(address(this).balance);
      status = state.Complete;
  }

  function seller_send_product() public payable
  {
    require(msg.sender == seller, 'only accessed by seller');
      require(status == state.Delivery_pending);
        isSeller = true; 
  }
  function delivery_recieved() public payable
  {
    require(msg.sender == buyer);
    require(status == state.Delivery_pending);
    isBuyer = true;
    status = state.Pending_fund_release;
    if(isSeller== true)
        release_fund();
  }

  function release_fund() private {
    if(isBuyer&&isSeller)
        seller.transfer((address(this).balance));
        status = state.Complete;
  }

  function withdraw_fund() public 
  {
    end = block.timestamp;
    require(status == state.Delivery_pending);
    require(msg.sender == buyer);
    if(isBuyer == false && isSeller == true) 
        seller.transfer(address(this).balance);
// time exceeds 30 days after the buyer has deposited in the escrow contract        
    else if(isBuyer &&! isSeller && end > start + 172800)  
    {
      require(address(this).balance !=0, 'Already money transferred');
      buyer.transfer(address(this).balance);
    }
    status = state.Complete;
  }
}
