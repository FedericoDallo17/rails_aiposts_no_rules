import axios from 'axios';

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:3001/api/v1';

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Request interceptor to add auth token
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Response interceptor to handle errors
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      localStorage.removeItem('token');
      localStorage.removeItem('user');
      window.location.href = '/sign-in';
    }
    return Promise.reject(error);
  }
);

// Authentication
export const auth = {
  signUp: (userData) => api.post('/auth/sign_up', { user: userData }),
  signIn: (email, password) => api.post('/auth/sign_in', { email, password }),
  changePassword: (currentPassword, newPassword) => 
    api.post('/auth/change_password', { current_password: currentPassword, new_password: newPassword }),
  changeEmail: (password, newEmail) => 
    api.post('/auth/change_email', { password, new_email: newEmail }),
  deleteAccount: (password) => 
    api.delete('/auth/delete_account', { data: { password } }),
};

// Users
export const users = {
  list: (page = 1) => api.get(`/users?page=${page}`),
  get: (id) => api.get(`/users/${id}`),
  getPosts: (id, page = 1) => api.get(`/users/${id}/posts?page=${page}`),
  getLikedPosts: (id, page = 1) => api.get(`/users/${id}/liked_posts?page=${page}`),
  getCommentedPosts: (id, page = 1) => api.get(`/users/${id}/commented_posts?page=${page}`),
  updateProfile: (data) => api.patch('/users/update_profile', { user: data }),
  updateProfilePicture: (file) => {
    const formData = new FormData();
    formData.append('profile_picture', file);
    return api.patch('/users/update_profile_picture', formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
  },
  updateCoverPicture: (file) => {
    const formData = new FormData();
    formData.append('cover_picture', file);
    return api.patch('/users/update_cover_picture', formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
  },
};

// Posts
export const posts = {
  list: (page = 1) => api.get(`/posts?page=${page}`),
  get: (id) => api.get(`/posts/${id}`),
  create: (postData) => api.post('/posts', { post: postData }),
  update: (id, postData) => api.patch(`/posts/${id}`, { post: postData }),
  delete: (id) => api.delete(`/posts/${id}`),
};

// Comments
export const comments = {
  list: (postId, page = 1) => api.get(`/posts/${postId}/comments?page=${page}`),
  create: (postId, content) => api.post(`/posts/${postId}/comments`, { comment: { content } }),
  delete: (id) => api.delete(`/comments/${id}`),
};

// Likes
export const likes = {
  likePost: (postId) => api.post(`/posts/${postId}/likes`),
  unlikePost: (postId) => api.delete(`/posts/${postId}/likes`),
  getPostLikes: (postId, page = 1) => api.get(`/posts/${postId}/likes?page=${page}`),
  likeComment: (commentId) => api.post(`/comments/${commentId}/likes`),
  unlikeComment: (commentId) => api.delete(`/comments/${commentId}/likes`),
  getCommentLikes: (commentId, page = 1) => api.get(`/comments/${commentId}/likes?page=${page}`),
};

// Reposts
export const reposts = {
  create: (postId) => api.post(`/posts/${postId}/reposts`),
  delete: (postId) => api.delete(`/posts/${postId}/reposts`),
  list: (postId, page = 1) => api.get(`/posts/${postId}/reposts?page=${page}`),
};

// Follows
export const follows = {
  follow: (userId) => api.post(`/users/${userId}/follow`),
  unfollow: (userId) => api.delete(`/users/${userId}/follow`),
  followers: (userId, page = 1) => api.get(`/users/${userId}/followers?page=${page}`),
  following: (userId, page = 1) => api.get(`/users/${userId}/following?page=${page}`),
};

// Notifications
export const notifications = {
  list: (page = 1) => api.get(`/notifications?page=${page}`),
  unread: (page = 1) => api.get(`/notifications/unread?page=${page}`),
  markAsRead: (id) => api.patch(`/notifications/${id}/mark_as_read`),
  markAsUnread: (id) => api.patch(`/notifications/${id}/mark_as_unread`),
  markAllAsRead: () => api.patch('/notifications/mark_all_as_read'),
};

// Feed
export const feed = {
  get: (page = 1) => api.get(`/feed?page=${page}`),
};

// Search
export const search = {
  users: (query, page = 1) => api.get(`/search/users?q=${encodeURIComponent(query)}&page=${page}`),
  posts: (query, sortBy = 'newest', page = 1) => 
    api.get(`/search/posts?q=${encodeURIComponent(query)}&sort_by=${sortBy}&page=${page}`),
};

export default api;

