import { Link } from 'react-router-dom';
import { useState } from 'react';
import { likes, reposts as repostsApi, posts as postsApi } from '../services/api';
import { useAuth } from '../contexts/AuthContext';

export default function PostCard({ post, onDelete }) {
  const { user } = useAuth();
  const [postData, setPostData] = useState(post);
  const [loading, setLoading] = useState(false);

  const handleLike = async () => {
    if (loading) return;
    setLoading(true);

    try {
      if (postData.liked_by_current_user) {
        await likes.unlikePost(postData.id);
        setPostData({
          ...postData,
          liked_by_current_user: false,
          likes_count: postData.likes_count - 1,
        });
      } else {
        await likes.likePost(postData.id);
        setPostData({
          ...postData,
          liked_by_current_user: true,
          likes_count: postData.likes_count + 1,
        });
      }
    } catch (error) {
      console.error('Failed to toggle like:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleRepost = async () => {
    if (loading) return;
    setLoading(true);

    try {
      if (postData.reposted_by_current_user) {
        await repostsApi.delete(postData.id);
        setPostData({
          ...postData,
          reposted_by_current_user: false,
          reposts_count: postData.reposts_count - 1,
        });
      } else {
        await repostsApi.create(postData.id);
        setPostData({
          ...postData,
          reposted_by_current_user: true,
          reposts_count: postData.reposts_count + 1,
        });
      }
    } catch (error) {
      console.error('Failed to toggle repost:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleDelete = async () => {
    if (!window.confirm('Are you sure you want to delete this post?')) return;
    
    try {
      await postsApi.delete(postData.id);
      onDelete(postData.id);
    } catch (error) {
      console.error('Failed to delete post:', error);
      alert('Failed to delete post');
    }
  };

  const formatDate = (dateString) => {
    const date = new Date(dateString);
    const now = new Date();
    const diffInSeconds = Math.floor((now - date) / 1000);
    
    if (diffInSeconds < 60) return 'just now';
    if (diffInSeconds < 3600) return `${Math.floor(diffInSeconds / 60)}m ago`;
    if (diffInSeconds < 86400) return `${Math.floor(diffInSeconds / 3600)}h ago`;
    return `${Math.floor(diffInSeconds / 86400)}d ago`;
  };

  return (
    <div className="bg-white rounded-lg shadow p-6">
      {postData.reposted_by && (
        <p className="text-sm text-gray-600 mb-2">
          🔁 Reposted by {postData.reposted_by.username}
        </p>
      )}
      
      <div className="flex items-start space-x-4">
        <Link to={`/profile/${postData.user.id}`}>
          {postData.user.profile_picture_url ? (
            <img
              src={postData.user.profile_picture_url}
              alt={postData.user.username}
              className="w-12 h-12 rounded-full"
            />
          ) : (
            <div className="w-12 h-12 rounded-full bg-blue-500 flex items-center justify-center text-white font-bold">
              {postData.user.username[0].toUpperCase()}
            </div>
          )}
        </Link>

        <div className="flex-1">
          <div className="flex items-center justify-between">
            <div>
              <Link to={`/profile/${postData.user.id}`} className="font-bold hover:underline">
                {postData.user.full_name}
              </Link>
              <span className="text-gray-600 ml-2">@{postData.user.username}</span>
              <span className="text-gray-500 ml-2">· {formatDate(postData.created_at)}</span>
            </div>
            {user?.id === postData.user.id && (
              <button
                onClick={handleDelete}
                className="text-red-600 hover:text-red-700 text-sm"
              >
                Delete
              </button>
            )}
          </div>

          <Link to={`/posts/${postData.id}`}>
            <p className="mt-2 text-gray-900 whitespace-pre-wrap">{postData.content}</p>
            {postData.tags && postData.tags.length > 0 && (
              <div className="mt-2 flex flex-wrap gap-2">
                {postData.tags.map((tag, index) => (
                  <span key={index} className="text-blue-600 text-sm">
                    #{tag}
                  </span>
                ))}
              </div>
            )}
          </Link>

          <div className="mt-4 flex items-center space-x-6 text-gray-600">
            <button
              onClick={handleLike}
              disabled={loading}
              className={`flex items-center space-x-2 hover:text-red-600 ${
                postData.liked_by_current_user ? 'text-red-600' : ''
              }`}
            >
              <span>{postData.liked_by_current_user ? '❤️' : '🤍'}</span>
              <span>{postData.likes_count}</span>
            </button>

            <Link to={`/posts/${postData.id}`} className="flex items-center space-x-2 hover:text-blue-600">
              <span>💬</span>
              <span>{postData.comments_count}</span>
            </Link>

            <button
              onClick={handleRepost}
              disabled={loading}
              className={`flex items-center space-x-2 hover:text-green-600 ${
                postData.reposted_by_current_user ? 'text-green-600' : ''
              }`}
            >
              <span>🔁</span>
              <span>{postData.reposts_count}</span>
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}

