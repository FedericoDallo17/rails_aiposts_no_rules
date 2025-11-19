import { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import { users, follows as followsApi } from '../services/api';
import { useAuth } from '../contexts/AuthContext';
import PostCard from '../components/PostCard';

export default function Profile() {
  const { userId } = useParams();
  const { user: currentUser } = useAuth();
  const [profile, setProfile] = useState(null);
  const [posts, setPosts] = useState([]);
  const [stats, setStats] = useState(null);
  const [loading, setLoading] = useState(true);
  const [following, setFollowing] = useState(false);

  useEffect(() => {
    fetchProfile();
  }, [userId]);

  const fetchProfile = async () => {
    try {
      setLoading(true);
      const [profileRes, postsRes] = await Promise.all([
        users.get(userId),
        users.getPosts(userId),
      ]);
      
      setProfile(profileRes.data.user);
      setStats(profileRes.data.stats);
      setPosts(postsRes.data.posts);
      setFollowing(profileRes.data.stats?.is_following || false);
    } catch (error) {
      console.error('Failed to fetch profile:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleFollow = async () => {
    try {
      if (following) {
        await followsApi.unfollow(userId);
        setFollowing(false);
        setStats({ ...stats, followers_count: stats.followers_count - 1 });
      } else {
        await followsApi.follow(userId);
        setFollowing(true);
        setStats({ ...stats, followers_count: stats.followers_count + 1 });
      }
    } catch (error) {
      console.error('Failed to toggle follow:', error);
    }
  };

  const handlePostDeleted = (postId) => {
    setPosts(posts.filter(post => post.id !== postId));
  };

  if (loading) {
    return <div className="text-center py-8">Loading profile...</div>;
  }

  if (!profile) {
    return <div className="text-center py-8">Profile not found</div>;
  }

  return (
    <div className="max-w-4xl mx-auto">
      <div className="bg-white rounded-lg shadow mb-6">
        {profile.cover_picture_url && (
          <img
            src={profile.cover_picture_url}
            alt="Cover"
            className="w-full h-48 object-cover rounded-t-lg"
          />
        )}
        
        <div className="p-6">
          <div className="flex items-start justify-between">
            <div className="flex items-center space-x-4">
              {profile.profile_picture_url ? (
                <img
                  src={profile.profile_picture_url}
                  alt={profile.username}
                  className="w-24 h-24 rounded-full -mt-12 border-4 border-white"
                />
              ) : (
                <div className="w-24 h-24 rounded-full bg-blue-500 flex items-center justify-center text-white font-bold text-2xl -mt-12 border-4 border-white">
                  {profile.username[0].toUpperCase()}
                </div>
              )}
              
              <div>
                <h1 className="text-2xl font-bold">{profile.full_name}</h1>
                <p className="text-gray-600">@{profile.username}</p>
              </div>
            </div>

            {currentUser?.id !== profile.id && (
              <button
                onClick={handleFollow}
                className={`px-6 py-2 rounded-full font-medium ${
                  following
                    ? 'bg-gray-200 text-gray-800 hover:bg-gray-300'
                    : 'bg-blue-600 text-white hover:bg-blue-700'
                }`}
              >
                {following ? 'Following' : 'Follow'}
              </button>
            )}
          </div>

          {profile.bio && (
            <p className="mt-4 text-gray-700">{profile.bio}</p>
          )}

          {profile.website && (
            <a
              href={profile.website}
              target="_blank"
              rel="noopener noreferrer"
              className="text-blue-600 hover:underline mt-2 inline-block"
            >
              {profile.website}
            </a>
          )}

          {profile.location && (
            <p className="text-gray-600 mt-2">📍 {profile.location}</p>
          )}

          <div className="flex space-x-6 mt-4 text-sm">
            <span>
              <strong>{stats?.posts_count || 0}</strong> Posts
            </span>
            <span>
              <strong>{stats?.followers_count || 0}</strong> Followers
            </span>
            <span>
              <strong>{stats?.following_count || 0}</strong> Following
            </span>
          </div>
        </div>
      </div>

      <div className="space-y-6">
        <h2 className="text-xl font-bold">Posts</h2>
        {posts.length === 0 ? (
          <div className="bg-white rounded-lg shadow p-6 text-center text-gray-600">
            No posts yet
          </div>
        ) : (
          posts.map((post) => (
            <PostCard key={post.id} post={post} onDelete={handlePostDeleted} />
          ))
        )}
      </div>
    </div>
  );
}

