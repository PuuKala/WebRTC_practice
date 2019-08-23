var room = 'huone1';

var webrtc = new SimpleWebRTC({
    url: 'http://localhost:8888/',
    localVideoEl: 'localVideo',
    remoteVideoEl: '',
    autoRequestMedia: true,
    debug: false,
    detectSpeakingEvents: true,
});

webrtc.on('readyToCall', function () {
    webrtc.joinRoom(room);
});

webrtc.on('videoAdded', function (video, peer) {
    console.log('video added ', peer);
    var remotes = document.getElementById('remotes');
    if (remotes) {
        var d = document.createElement('div');
        d.className = 'videoContainer';
        d.id = 'container_' + webrtc.getDomId(peer);
        d.appendChild(video);
        video.onclick = function () {
            video.style.width = video.videoWidth + 'px';
            video.style.height = video.videoHeight + 'px';
        };
        remotes.appendChild(d);
    }
});

webrtc.on('videoRemoved', function (video, peer) {
    console.log('video removed ', peer);
    var remotes = document.getElementById('remotes');
    var el = document.getElementById('container_' + webrtc.getDomId(peer));
    if (remotes && el) {
        remotes.removeChild(el);
    }
});
