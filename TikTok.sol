// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

contract TikTok {
  constructor() public {

   
  }
   struct Video {
      string caption;
      string url;
      uint256 likes;
      uint256 dislikes;
      address owner;
      address[] likedUsers;

    }

    mapping(address => mapping(uint => bool)) public likedUsers;

    mapping(address => mapping(uint => bool)) public dislikedUsers;

    mapping(uint => Video) public videos;
    mapping(uint256 => uint256) public likes;

    uint public videoCount = 0;

    function createVideo(string memory _caption, string memory _url) public {
      require(bytes(_caption).length > 0);
      require(bytes(_url).length > 0);
      require(msg.sender != address(0));
      videoCount++;
      videos[videoCount] = Video(_caption, _url, 0, 0, msg.sender, new address[](0));

      // Trigger an event
      emit VideoCreated(videoCount, _caption, _url, 0, 0, msg.sender);
      emit VideoLiked(videoCount, 0, msg.sender);
      emit VideoDisliked(videoCount, 0, msg.sender);
    }

    function likeVideo(uint256 _id) public {
      Video storage _video = videos[_id];
      require(_id > 0 && _id <= videoCount);
      require(msg.sender != address(0));
      require(likedUsers[msg.sender][_id] == false, "you already liked this video");
      require(!likedUsers[msg.sender][_id]);
      require(!dislikedUsers[msg.sender][_id]);
      
      likes[_id] = likes[_id] + 1;
      _video.likes++;
      _video.likedUsers.push(msg.sender);
      likedUsers[msg.sender][_id] = true;
      emit VideoLiked(_id, videos[_id].likes, msg.sender);
    }

    function dislikeVideo(uint _id) public {
      require(_id > 0 && _id <= videoCount);
      require(msg.sender != address(0));
      require(!likedUsers[msg.sender][_id]);
      require(!dislikedUsers[msg.sender][_id]);
      videos[_id].dislikes++;
      dislikedUsers[msg.sender][_id] = true;
      emit VideoDisliked(_id, videos[_id].dislikes, msg.sender);
    }

    // function getNumberOfVideos() public view returns(uint) {
    //   return videoCount;
    // }

    function getVideos() public view returns(Video[] memory) {
      Video[] memory _videos = new Video[](videoCount);
      for(uint i = 0; i < videoCount; i++) {
        _videos[i] = videos[i + 1];
      }
      return _videos;
    }
    

    function uploadVideo(string memory _caption, string memory _url) public {
      require(bytes(_caption).length > 0);
      require(bytes(_url).length > 0);
      require(msg.sender != address(0));
      videoCount++;
      videos[videoCount] = Video(_caption, _url, 0, 0, msg.sender, new address[](0));

      // Trigger an event
      emit VideoCreated(videoCount, _caption, _url, 0, 0, msg.sender);
      emit VideoLiked(videoCount, 0, msg.sender);
      emit VideoDisliked(videoCount, 0, msg.sender);
    }
    event VideoCreated(
      uint id,
      string caption,
      string url,
      uint256 likes,
      uint256 dislikes,
      address owner
    );
    event VideoLiked (uint id, uint256 likes, address owner);
    event VideoDisliked (uint id, uint256 dislikes, address owner);


    function getNumberOfVideos() public view returns(uint) {
      return videoCount;
    }

}
